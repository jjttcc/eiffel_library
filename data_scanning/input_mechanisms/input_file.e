indexing
	description: "A text file used only for input"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class INPUT_FILE inherit

	PLAIN_TEXT_FILE
		export
			{NONE} all
			{ANY} close
		end

	INPUT_SEQUENCE
		rename
			index as position
		undefine
			off, item
		end

creation

	make_open_read, make_create_read_write, make_open_read_write

feature -- Access

	field_separator: STRING
			-- Field separator used in `advance_to_next_field'

	record_separator: STRING
			-- Record separator used in `advance_to_next_record'

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

feature -- Basic operations

	advance_to_next_field is
			-- Advance the cursor to the next field.
			-- Set error_occurred and error_string if an error is encountered.
		local
			i: INTEGER
		do
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
						error_string := "Incorrect field separator detected."
					end
				end
				i := i + 1
			end
		end

	advance_to_next_record is
			-- Advance the cursor to the next record.
			-- Set error_occurred and error_string if an error is encountered.
		local
			i: INTEGER
		do
			from
				i := 1
			variant
				record_separator.count + 1 - i
			until
				i > record_separator.count
			loop
				-- If record_separator @ i is a tab or space or newline,
				-- it will have been eaten in the last read_x call.  If it's
				-- something else, then the character still needs to be eaten.
				if
					not (record_separator @ i = '%T' or
						record_separator @ i = ' ' or
						record_separator @ i = '%N')
				then
					read_character
					if
						last_character /= record_separator @ i
					then
						error_occurred := True
						error_string := "Incorrect record separator detected."
					end
				end
				i := i + 1
			end
		end

invariant

	exists_and_is_open_read: exists and not is_closed implies is_open_read

end -- INPUT_FILE
