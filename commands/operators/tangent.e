indexing
	description: "Trigonometric tangent operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class TANGENT inherit

	UNARY_MATH_OPERATOR
		redefine
			operate
		end

creation

	make

feature {NONE} -- Basic operations

	operate (v: REAL) is
			-- Null action by default
		do
			value := tangent (v)
		end

end
