indexing
	description:
		"Value setter with read_value procedure defined to read the next %
		%string value from the input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

deferred class STRING_SETTER inherit

	VALUE_SETTER

feature {NONE}

	read_value (stream: INPUT_SEQUENCE) is
		do
			stream.read_string
		end

end -- class STRING_SETTER
