indexing
	description:
		"Value setter with read_value procedure defined to read the next %
		%real value from the input"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class REAL_SETTER inherit

	VALUE_SETTER

	MATH_CONSTANTS

feature {NONE}

	read_value (stream: INPUT_SEQUENCE) is
		do
			stream.read_real
		end

end -- class REAL_SETTER
