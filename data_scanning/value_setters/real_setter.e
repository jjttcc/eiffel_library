indexing
	description:
		"Value setter with read_value procedure defined to read the next %
		%real value from the input"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class REAL_SETTER inherit

	VALUE_SETTER

	MATH_CONSTANTS

feature {NONE}

	read_value (stream: IO_MEDIUM) is
		do
			stream.read_real
		end

end -- class REAL_SETTER
