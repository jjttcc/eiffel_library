indexing
	description: "Binary operator that implements multiplication"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class MULTIPLICATION

inherit

	BINARY_OPERATOR [REAL, REAL]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: REAL) is
		do
			value := v1 * v2
		end

end -- class MULTIPLICATION
