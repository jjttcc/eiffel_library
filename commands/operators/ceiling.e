indexing
	description: "Mathematical ceiling operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class CEILING inherit

	UNARY_MATH_OPERATOR

creation

	make

feature {NONE} -- Basic operations

	operate (v: REAL) is
			-- Null action by default
		do
			value := ceiling (v)
		end

end
