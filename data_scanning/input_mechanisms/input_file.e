note
	description: "Text files/record-sequences used only for input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"
	note1: "This version reads one line/record at a time and 'split's it into %
		%its component fields."

--!!!!Note: This file should be used exclusively for file-based input for the
--Windows version because a bug (apparently in ISE's library) causes
--OPTIMIZED_INPUT_FILE to not work correctly on Windows.

--!!!REminders: record_separator is may no longer be needed
--for line-at-a-time ...
class INPUT_FILE inherit

	PLAIN_TEXT_FILE
		rename
			start as implementation_start
		export
			{NONE} all
			{ANY} after, open_read, date, count, position, back,
			is_open_write, put_string, file_readable, extendible, file_pointer
		undefine
			read_integer, read_real, read_double
		redefine
			make, make_create_read_write
		end

	INPUT_MEDIUM
		rename
			handle as descriptor, handle_available as descriptor_available
		undefine
			implementation_start,
			read_line_thread_aware,		-- !!!check!!!
			read_stream_thread_aware	-- !!!check!!!
		select
			start
		end

	ITERABLE_INPUT_SEQUENCE
		rename
			index as position
		undefine
			off
		end

creation

	make, make_create_read_write

feature -- Initialization

	make (fn: STRING)
		do
			Precursor (fn)
			field_separator := "%T"
		ensure then
			default_field_sep: field_separator.is_equal ("%T")
		end

	make_create_read_write (fn: STRING)
		do
			Precursor (fn)
			field_separator := "%T"
		ensure then
			default_field_sep: field_separator.is_equal ("%T")
		end

feature -- Status report

	data_available: BOOLEAN
		do
			Result := not off
		ensure then
			Result = not off
		end

feature -- Cursor movement

	position_cursor (p: INTEGER)
			-- Move the file cursor to the absolute position `p' and
			-- initialize `field_index' and `record_index' to 1.
			-- (The first cursor position is 0.)
		require
			is_open: not is_closed
			p_valid: p >= 0 and p < count
		do
			go (p)
			record_index_implementation := 1
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

feature {NONE} -- Implementation

	save_position
		do
			saved_position := position
		end

	restore_position (offset: INTEGER)
			-- Restore `position' to `saved_position' + offset
		do
			file_go (file_pointer, saved_position + offset)
		end

	saved_position: INTEGER

invariant

	exists_and_is_open_read: exists and not is_closed implies is_open_read

end
