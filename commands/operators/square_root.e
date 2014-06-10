note
	description: "A square root operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class SQUARE_ROOT inherit

	UNARY_MATH_OPERATOR

creation

	make

feature {NONE} -- Basic operations

	operate (v: REAL)
		do
			value := sqrt (v)
		end

end -- class SQUARE_ROOT
