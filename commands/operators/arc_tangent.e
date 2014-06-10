note
	description: "Trigonometric arctangent operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class ARC_TANGENT inherit

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
			value := arc_tangent (v)
		end

end
