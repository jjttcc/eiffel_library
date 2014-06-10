note
	description: "Binary operator whose result is its left operand to the %
		%power of its right operand"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class POWER

inherit

	BINARY_OPERATOR [REAL, REAL]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: REAL)
		do
			value := v1 ^ v2
		end

end -- class POWER
