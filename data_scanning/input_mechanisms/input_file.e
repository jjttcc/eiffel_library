indexing
	description: "A text file used only for input"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class INPUT_FILE inherit

	BILINEAR_INPUT_SEQUENCE
		rename
			index as position
		undefine
			off
		end

	PLAIN_TEXT_FILE
		export
			{NONE} all
			{ANY} close
		end

creation

	make_open_read, make_create_read_write, make_open_read_write

invariant

	exists_and_is_open_read: exists and not is_closed implies is_open_read

end -- INPUT_FILE
