indexing
	description: "Useful mathematical constants not in ISE library";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class MATH_CONSTANTS inherit

	SINGLE_MATH

feature -- Access

	epsilon: REAL is 0.00001

feature -- Utility

	reals_equal (r1, r2: REAL): BOOLEAN is
			-- Is `r1' equal to `r2' within a tolerance of `epsilon'?
		do
			Result := rabs (r1 - r2) < epsilon
		ensure
			definition: Result = (rabs (r1 - r2) < epsilon)
		end

end -- class MATH_CONSTANTS
