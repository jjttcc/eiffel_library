indexing
	description:
		"A unary operator that produces the absolute value of its operand"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class ABSOLUTE_VALUE inherit

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
			value := v.abs
		end

end
