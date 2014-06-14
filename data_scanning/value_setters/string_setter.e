note
	description:
		"Value setter with read_value procedure defined to read the next %
		%string value from the input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class STRING_SETTER [G] inherit

	VALUE_SETTER [G]

feature {NONE}

	read_value (stream: INPUT_SEQUENCE)
		do
			stream.read_string
		end

end -- class STRING_SETTER
