note
	description: "Natural logarithm operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class LOG inherit

	UNARY_MATH_OPERATOR

creation

	make

feature {NONE} -- Basic operations

	operate (v: REAL)
			-- Null action by default
		do
			value := log (v)
		end

end -- class LOG
