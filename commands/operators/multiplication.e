note
	description: "Binary operator that implements multiplication"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class MULTIPLICATION

inherit

	BINARY_OPERATOR [REAL, REAL]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: REAL)
		do
			value := v1 * v2
		end

end -- class MULTIPLICATION
