indexing
	description: "Media used only for input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

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

	field_index: INTEGER is
		do
			if current_record /= Void then
				Result := current_record.index
			end
		end

	record_index: INTEGER

	field_count: INTEGER is
		do
			check
				readable: readable
			end
			if current_record = Void then
				split_current_record
			end
			Result := current_record.count
		end

feature -- Status report

	after_last_record: BOOLEAN

	last_error_fatal: BOOLEAN

feature -- Cursor movement

	advance_to_next_field is
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

	advance_to_next_record is
			-- Advance the cursor to the next record.
			-- Set error_occurred and error_string if an error is encountered.
		local
			i: INTEGER
		do
			last_error_fatal := False
			error_occurred := False
			record_index := record_index + 1
			if data_available then
				split_current_record
				current_record.start
				if current_record.count <= 1 then
					after_last_record := True
				end
			else
				after_last_record := True
			end
		end

	discard_current_record is
		do
print ("discard current record called" + "%N")
--!!!Kept as a separate routine from `advance_to_next_record',
-- for now, for testing/debugging.
			advance_to_next_record
		end

	start is
		do
			implementation_start
			record_index := 1
			after_last_record := not data_available
			if not after_last_record then
				split_current_record
				current_record.start
			end
		ensure then
			indexes_set_to_1: not after_last_record implies
				field_index = 1 and record_index = 1
		end

feature -- Element change

	set_field_separator (arg: STRING) is
			-- Set field_separator to `arg'.
		require
			arg_not_void: arg /= Void
		do
			field_separator := arg
		ensure
			field_separator_set: field_separator = arg and
				field_separator /= Void
		end

	set_record_separator (arg: STRING) is
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

	read_integer is
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

	read_real is
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

	read_double is
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

	read_string is
		do
			if not current_record.exhausted then
				last_string := current_record.item
			else
				create last_string.make (0)
			end
		end

	read_date is
		do
			-- @@Stub
		end

	read_line is
			-- Read characters until a new line or end of medium.
			-- Make result available in `last_string'.
		deferred
		end

feature {NONE} -- Hook routines

	implementation_start is
			-- Implementation-dependent behavior needed for `start'
		do
			do_nothing	 -- Redefine if needed.
		end

	data_available: BOOLEAN is
			-- Are data currently available for input?
		deferred
		end

feature {NONE} -- Implementation

	current_record: LIST [STRING]
			-- The record (line) currently being parsed

--!!!Perhaps this should be called split_next_record?
	split_current_record is
			-- Scan the current line (data record) and split the result into
			-- `current_record'.
		require
			not_at_end: not after_last_record
		do
			read_line
			current_record := last_string.split (field_separator @ 1)
		ensure
			current_record_exists: current_record /= Void
		end

--!!!This feature needs to be moved to a utility class:
	is_tab_space_or_newline (c: CHARACTER): BOOLEAN is
			-- Is `c' a tab, space, or newline character?
		do
			Result := c = '%T' or c = ' ' or c = '%N' or c = '%R'
		end

feature {NONE} -- Implementation - error messages

--!!!!Not used - remove?
	incorrect_field_separator_msg: STRING is "Incorrect field separator %
		%character detected"

--!!!!Not used - remove?
	incorrect_record_separator_msg: STRING is "Incorrect record separator %
		%character detected"

	too_few_fields_msg: STRING is
		do
			Result := "Not enough fields in record # " + record_index.out +
				": " + current_record.count.out
		end

	non_real_msg: STRING is
		require
			current_field_exists: current_record /= Void and then
				not current_record.exhausted
		do
			Result := "Real value expected, got" + current_record.item
		end

	non_integer_msg: STRING is
		require
			current_field_exists: current_record /= Void and then
				not current_record.exhausted
		do
			Result := "Integer value expected, got" + current_record.item
		end

invariant

	one_character_field_separator: field_separator /= Void and then
		field_separator.count = 1

end
