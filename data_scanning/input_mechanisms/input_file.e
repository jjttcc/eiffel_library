indexing
	description: "A text file/record sequence used only for input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

--!!!REminders: record_separator is no longer needed ...
class INPUT_FILE inherit

	PLAIN_TEXT_FILE
		rename
			make as file_make, make_create_read_write as
				file_make_create_read_write
		export
			{NONE} all
			{ANY} close, after, exists, open_read, is_closed, date, count,
			position, is_open_read
		redefine
			start ,read_integer ,read_real ,read_double
		end

	INPUT_RECORD_SEQUENCE

	ITERABLE_INPUT_SEQUENCE
		rename
			index as position
		undefine
			off
		end

creation

	make, make_create_read_write

feature -- Initialization

--	make (fn, field_sep: STRING) is
	make (fn: STRING) is
		require
--			args_exist: fn /= Void and field_sep /= Void
--			one_character_field_separator: field_sep.count = 1
		do
			make_open_read (fn)
--			field_separator := clone (field_sep)
		end

	make_create_read_write (fn: STRING) is
		do
			file_make_create_read_write (fn)
		end

feature -- Access

	last_date: DATE

	field_separator: STRING
			-- Field separator used in `advance_to_next_field'

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
		local
			fcount: INTEGER
			s: STRING
			end_of_record: BOOLEAN
			su: expanded STRING_UTILITIES
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
if record_index >= 1999 then
	print ("ri: " + record_index.out + "%N")
end
			if not off then
				split_current_record
				current_record.start
				if current_record.count <= 1 then
					after_last_record := True
				end
			else
				after_last_record := True
			end
			--!!!!set after_last_record
debug ("old code")
-- If just before the end-of-file, force EOF.
if not end_of_file then
	check
		is_readable: readable
	end
	read_character
	check
		not_closed_or_empty: count > 0 and not is_closed
	end
	if not end_of_file then
		back
	else
		after_last_record := True
	end
else
	after_last_record := True
end
end -- debug
		end

	discard_current_record is
		local
			first_rsep_char: CHARACTER
			last_character_was_record_separator: BOOLEAN
		do
print ("discard current record called" + "%N")
			first_rsep_char := record_separator @ 1
			if
				not before and not (field_index = 1) and
				is_tab_space_or_newline (first_rsep_char)
			then
				back
				read_character
				if last_character = first_rsep_char then
					last_character_was_record_separator := True
				end
			end
			if not last_character_was_record_separator then
				from
					read_character
				until
					last_character = first_rsep_char or end_of_file
				loop
					read_character
				end
				if not is_tab_space_or_newline (last_character) then
					back
				end
				advance_to_next_record
			end
			-- If just before the end-of-file, force EOF.
			read_character
			check
				not_closed_or_empty: count > 0 and not is_closed
			end
			if not after then
				back
			else
				after_last_record := True
			end
		end

	start is
		do
			Precursor
			record_index := 1
			after_last_record := count = 0
			if not after_last_record then
				split_current_record
				current_record.start
			end
		ensure then
			indexes_set_to_1: not after_last_record implies
				field_index = 1 and record_index = 1
		end

	position_cursor (p: INTEGER) is
			-- Move the file cursor to the absolute position `p' and
			-- initialize `field_index' and `record_index' to 1.
			-- (The first cursor position is 0.)
		require
			is_open: not is_closed
			p_valid: p >= 0 and p < count
		do
			go (p)
			record_index := 1
			after_last_record := count = position
			if not after_last_record then
				split_current_record
				current_record.start
			end
		ensure
			position_set: position = p
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

feature {NONE} -- Implementation

	current_record: LIST [STRING]
			-- The record (line) currently being parsed

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

	is_tab_space_or_newline (c: CHARACTER): BOOLEAN is
			-- Is `c' a tab, space, or newline character?
		do
			Result := c = '%T' or c = ' ' or c = '%N' or c = '%R'
		end

	current_string_matches (s: STRING): BOOLEAN is
			-- Does the string at the current cursor match `s'?
		local
			i: INTEGER
		do
			if readable then
				save_position
				Result := True
				from i := 1 until
					i = s.count + 1 or
					not Result or after
				loop
					read_character
					if s @ i /= last_character then
						Result := False
					end
					i := i + 1
				end
				if Result and after then
					Result := i = s.count + 1
				end
				restore_position (0)
			end
		end

	save_position is
		do
			saved_position := position
		end

	restore_position (offset: INTEGER) is
			-- Restore `position' to `saved_position' + offset
		do
			file_go (file_pointer, saved_position + offset)
		end

	saved_position: INTEGER

feature {NONE} -- Implementation - error messages

	incorrect_field_separator_msg: STRING is "Incorrect field separator %
		%character detected"

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

	exists_and_is_open_read: exists and not is_closed implies is_open_read
	one_character_field_separator: field_separator /= Void and then
		field_separator.count = 1

end -- INPUT_FILE
