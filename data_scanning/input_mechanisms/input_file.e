indexing
	description: "A text file/record sequence used only for input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class INPUT_FILE inherit

	PLAIN_TEXT_FILE
		export
			{NONE} all
			{ANY} close, after, exists, open_read, is_closed, date, count,
			position, is_open_read
		redefine
			start
		end

	INPUT_RECORD_SEQUENCE

	ITERABLE_INPUT_SEQUENCE
		rename
			index as position
		undefine
			off
		end

creation

	make_open_read, make_create_read_write, make_open_read_write, make

feature -- Access

	last_date: DATE

	field_separator: STRING
			-- Field separator used in `advance_to_next_field'

	record_separator: STRING
			-- Record separator used in `advance_to_next_record'

	field_index: INTEGER

	record_index: INTEGER

--!!!:
	field_count: INTEGER is
		local
			saved_position, fcount: INTEGER
			s: STRING
			end_of_record: BOOLEAN
			su: expanded STRING_UTILITIES
		do
print ("IF.field_count called" + "%N")
			saved_position := position
			check
				readable: readable
			end
			from
				s := ""
			until
				end_of_record
			loop
				read_character
				if last_character = record_separator @ 1 then
					if record_separator.count = 1 then
						end_of_record := True
					else
						end_of_record := current_string_matches (
						record_separator.substring(2, record_separator.count))
						if not end_of_record then
							back
							read_character
						end
					end
				end
				if not end_of_record then
					if after then
						end_of_record := True
					else
						s.extend (last_character)
					end
				end
			end
			go (saved_position)
			if not s.is_empty then
				su.set_target (s)
				fcount := su.tokens (field_separator).count
				if field_index = 0 or else fcount = field_index then
					Result := fcount
				else
					Result := fcount + field_index - 1
				end
print ("fc - fcount, field_index, result: " + fcount.out + ", " +
field_index.out + ", " + Result.out + "%N")
			end
if Result > 6 then print ("OH-OHHHHHHHHHHHHHHH!!!" + "%N") end
		end

feature -- Status report

	after_last_record: BOOLEAN

--!!!!!!:
	after_last_record_old_remove_me_please: BOOLEAN is
		do
			Result := after and then field_index = 1
print ("IF.after last record, field_index: " + Result.out +
", " + field_index.out + "%N")
		end

	last_error_fatal: BOOLEAN

feature -- Cursor movement

	advance_to_next_field is
			-- Advance the cursor to the next field.
			-- Set error_occurred and error_string if an error is encountered.
		local
			i: INTEGER
		do
--!!!:
--print ("IF.field_count: " + field_count.out + "%N")
			last_error_fatal := False
			error_occurred := False
			from
				i := 1
			variant
				field_separator.count + 1 - i
			until
				i > field_separator.count
			loop
				-- If field_separator @ i is a tab or space, it will have
				-- been eaten in the last read_x call (idiosyncracy of an
				-- PLAIN_TEXT_FILE).  If it's something else, then the
				-- character still needs to be eaten.
				if
					not (field_separator @ i = '%T' or
						field_separator @ i = ' ')
				then
					read_character
					if
						last_character /= field_separator @ i
					then
						error_occurred := True
						error_string := "Incorrect field separator %
							%character detected: '"
						error_string.extend (last_character)
						error_string.append ("'.")
					end
				end
				i := i + 1
			end
			field_index := field_index + 1
		end

--!!!:
	advance_to_next_record is
			-- Advance the cursor to the next record.
			-- Set error_occurred and error_string if an error is encountered.
		local
			i: INTEGER
		do
if record_index = 249 then print ("STOP!" + "%N") end
print ("[1] IF.advnrec - eof: " + end_of_file.out + "%N")
			last_error_fatal := False
			error_occurred := False
			from
				i := 1
			variant
				record_separator.count + 1 - i
			until
				i > record_separator.count or last_error_fatal
			loop
				-- If record_separator @ i is a tab or space or newline,
				-- it will have been eaten in the last read_x call.  If it's
				-- something else, then the character still needs to be eaten.
				if
					not is_tab_space_or_newline (record_separator @ i)
				then
print ("[1] anr - read_char" + "%N")
io.output.flush
					read_character
					if
						last_character /= record_separator @ i
					then
						error_occurred := True
						last_error_fatal := True
						error_string := "Incorrect record separator %
							%character detected: '"
						error_string.extend (last_character)
						error_string.append ("'.")
					end
				end
				i := i + 1
			end
			field_index := 1
			record_index := record_index + 1
			-- If just before the end-of-file, force EOF.
print ("[2] anr - read_char" + "%N")
io.output.flush
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
print ("[2] IF.advnrec - eof: " + end_of_file.out + "%N")
		end

	discard_current_record is
		local
			first_rsep_char: CHARACTER
			last_character_was_record_separator: BOOLEAN
		do
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
			field_index := 1
			record_index := 1
			after_last_record := count = 0
		end

--!!!:
	position_cursor (p: INTEGER) is
			-- Move the file cursor to the absolute position `p' and
			-- initialize `' and `' to 1.
			-- (The first cursor position is 0.)
		require
			is_open: not is_closed
			p_valid: p >= 0 and p < count
		do
			go (p)
			field_index := 1
			record_index := 1
			after_last_record := count = position
if after_last_record then print ("ODD: poscurs - count = position" + "%N") end
		ensure
			position_set: position = p
			indexes_set_to_1: field_index = 1 and record_index = 1
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

	read_string is
		do
			create last_string.make (0)
			from
				read_character
			until
				last_character = field_separator @ 1 or
				last_character = record_separator @ 1 or end_of_file
			loop
				last_string.extend (last_character)
				read_character
			end
			if
				not (last_character = record_separator @ 1) or else
				not is_tab_space_or_newline (record_separator @ 1)
				-- Don't move back if record_separator is a tab, space,
				-- or newline and last_character = record_separator @ 1.
			then
				back
			end
		end

	read_date is
		do
			-- @@Stub
		end

feature {NONE} -- Implementation

	is_tab_space_or_newline (c: CHARACTER): BOOLEAN is
			-- Is `c' a tab, space, or newline character?
		do
			Result := c = '%T' or c = ' ' or c = '%N' or c = '%R'
		end

	current_string_matches (s: STRING): BOOLEAN is
			-- Does the string at the current cursor match `s'?
		local
			saved_position, i: INTEGER
		do
			if readable then
				saved_position := position
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
				go (saved_position)
			end
		end

invariant

	exists_and_is_open_read: exists and not is_closed implies is_open_read

end -- INPUT_FILE
