note
	description: "Useful mathematical constants not in ISE library";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class MATH_CONSTANTS inherit

	DOUBLE_MATH

feature -- Access

	epsilon: REAL = 0.00001

feature -- Utility

	reals_equal (r1, r2: DOUBLE): BOOLEAN
			-- Is `r1' equal to `r2' within a tolerance of `epsilon'?
		do
			Result := dabs (r1 - r2) < epsilon
		ensure
			definition: Result = (dabs (r1 - r2) < epsilon)
		end

end -- class MATH_CONSTANTS
