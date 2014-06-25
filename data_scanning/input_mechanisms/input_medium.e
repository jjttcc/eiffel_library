note
	description: "Media used only for input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

--!!!REminders: record_separator is no longer needed for line-at-a-time ...
deferred class INPUT_MEDIUM inherit

	INPUT_RECORD_SEQUENCE

	IO_MEDIUM
		export
			{NONE} all
			{ANY} exists, is_closed, is_open_read, close
		undefine
			is_plain_text
		end

feature -- Access

	last_date: DATE

	field_separator: STRING
			-- Field separator used in `advance_to_next_field'

--!!!Not needed?:
	record_separator: STRING
			-- Record separator used in `advance_to_next_record'

	field_index: INTEGER
		do
			if current_record /= Void then
				Result := current_record.index
			end
		end

	record_index: INTEGER
		do
			Result := record_index_implementation
		end

	field_count: INTEGER
		do
			if current_record = Void then
				split_current_record
			end
			if current_record /= Void then
				Result := current_record.count
			else
				Result := 0
			end
		end

feature -- Status report

	after_last_record: BOOLEAN

	last_error_fatal: BOOLEAN

feature -- Cursor movement

	advance_to_next_field
			-- Advance the cursor to the next field.
			-- Set error_occurred and error_string if an error is encountered.
		do
			last_error_fatal := False
			error_occurred := False
			if not current_record.exhausted then
				current_record.forth
			else
				error_occurred := True
				error_string := too_few_fields_msg
			end
		end

	advance_to_next_record
			-- Advance the cursor to the next record.
			-- Set error_occurred and error_string if an error is encountered.
		do
			last_error_fatal := False
			error_occurred := False
			record_index_implementation := record_index_implementation + 1
			if data_available then
				split_current_record
				current_record.start
				if at_end_of_input then
					after_last_record := True
				end
			else
				after_last_record := True
			end
		end

	discard_current_record
		do
print ("discard current record called" + "%N")
--!!!Kept as a separate routine from `advance_to_next_record',
-- for now, for testing/debugging.
			advance_to_next_record
		end

	start
		do
			implementation_start
			record_index_implementation := 1
			after_last_record := not data_available
			if not after_last_record then
				if split_current_record_on_start then
					split_current_record
				end
				current_record.start
			end
		ensure then
			indexes_set_to_1: not after_last_record implies
				field_index = 1 and record_index = 1
		end

feature -- Element change

	set_field_separator (arg: STRING)
			-- Set field_separator to `arg'.
		require
			arg_not_void: arg /= Void
		do
			field_separator := arg
		ensure
			field_separator_set: field_separator = arg and
				field_separator /= Void
		end

	set_record_separator (arg: STRING)
			-- Set record_separator to `arg'.
		require
			arg_not_void: arg /= Void
		do
			record_separator := arg
		ensure
			record_separator_set: record_separator = arg and
				record_separator /= Void
		end

feature -- Input

	read_integer
		do
			if not current_record.exhausted then
				if current_record.item.is_integer then
					last_integer := current_record.item.to_integer
				else
					error_occurred := True
					error_string := non_integer_msg
				end
			else
				error_occurred := True
				error_string := too_few_fields_msg
			end
		end

	read_real
		do
			if not current_record.exhausted then
				if current_record.item.is_real then
					last_real := current_record.item.to_real
				else
					error_occurred := True
					error_string := non_real_msg
				end
			else
				error_occurred := True
				error_string := too_few_fields_msg
			end
		end

	read_double
		do
			if not current_record.exhausted then
				if current_record.item.is_double then
					last_double := current_record.item.to_double
				else
					error_occurred := True
					error_string := non_real_msg
				end
			else
				error_occurred := True
				error_string := too_few_fields_msg
			end
		end

	read_string
		do
			if not current_record.exhausted then
				last_string := current_record.item
			else
				create last_string.make (0)
			end
		end

	read_date
		do
			-- @@Stub
		end

	read_line
			-- Read characters until a new line or end of medium.
			-- Make result available in `last_string'.
		deferred
		end

feature {NONE} -- Hook routines

	implementation_start
			-- Implementation-dependent behavior needed for `start'
		do
			do_nothing	 -- Redefine if needed.
		end

	data_available: BOOLEAN
			-- Are data currently available for input?
		deferred
		end

	at_end_of_input: BOOLEAN
			-- Has the end of the input stream been reached?
		do
				Result := current_record.count <= 1
		end

	split_current_record_on_start: BOOLEAN
			-- Should `split_current_record' be called by `start'?
		once
			Result := True	-- Redefine if needed.
		end

feature {NONE} -- Implementation

	current_record: LIST [STRING]
			-- The record (line) currently being parsed

	record_index_implementation: INTEGER

--!!!Perhaps this should be called split_next_record?
	split_current_record
			-- Scan the current line (data record) and split the result into
			-- `current_record'.
		require
			not_at_end: not after_last_record
		do
			if readable then
				read_line
				current_record := last_string.split (field_separator @ 1)
			else
				error_occurred := True
				error_string := medium_not_readable_msg
print ("OH-OH!!!: " + error_string + "%N")
			end
		ensure
			current_record_exists: not error_occurred implies
				current_record /= Void
		end

--!!!This feature needs to be moved to a utility class:
	is_tab_space_or_newline (c: CHARACTER): BOOLEAN
			-- Is `c' a tab, space, or newline character?
		do
			Result := c = '%T' or c = ' ' or c = '%N' or c = '%R'
		end

feature {NONE} -- Implementation - error messages

	too_few_fields_msg: STRING
		do
			Result := "Not enough fields in record # " + record_index.out +
				": " + current_record.count.out
		end

	non_real_msg: STRING
		require
			current_field_exists: current_record /= Void and then
				not current_record.exhausted
		do
			Result := "Real value expected, got" + current_record.item
		end

	non_integer_msg: STRING
		require
			current_field_exists: current_record /= Void and then
				not current_record.exhausted
		do
			Result := "Integer value expected, got" + current_record.item
		end

	medium_not_readable_msg: STRING
		do
			Result := "Input medium (" + generating_type + ") is not readable"
		end

invariant

	one_character_field_separator: field_separator /= Void and then
		field_separator.count = 1

end
