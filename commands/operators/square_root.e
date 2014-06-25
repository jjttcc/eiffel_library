note
	description: "A square root operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class SQUARE_ROOT inherit

	UNARY_MATH_OPERATOR

creation

	make

feature {NONE} -- Basic operations

	operate (v: DOUBLE)
		do
			value := sqrt (v)
		end

end -- class SQUARE_ROOT
