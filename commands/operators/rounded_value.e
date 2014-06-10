note
	description:
		"A unary operator that produces the rounded value of its real operand"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class ROUNDED_VALUE inherit

	UNARY_MATH_OPERATOR
		redefine
			operate
		end

creation

	make

feature {NONE} -- Basic operations

	operate (v: REAL)
			-- Null action by default
		do
			value := v.rounded
		end

end
