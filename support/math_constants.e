note
	description: "Useful mathematical constants not in ISE library";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

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
