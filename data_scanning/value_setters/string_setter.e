indexing
	description:
		"Value setter with read_value procedure defined to read the next %
		%string value from the input"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class STRING_SETTER inherit

	VALUE_SETTER

feature {NONE}

	read_value (stream: INPUT_SEQUENCE) is
		do
			stream.read_string
		end

end -- class STRING_SETTER
