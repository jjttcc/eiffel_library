indexing
	description: "Trigonometric sine operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class SINE inherit

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
			value := sine (v)
		end

end
