note
	description: "Mathematical ceiling operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class CEILING inherit

	UNARY_MATH_OPERATOR

creation

	make

feature {NONE} -- Basic operations

	operate (v: DOUBLE)
			-- Null action by default
		do
			value := ceiling (v)
		end

end
