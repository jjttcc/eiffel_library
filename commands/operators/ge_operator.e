note
	description: "Greater-than-or-equal-to operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class GE_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, DOUBLE]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: DOUBLE)
		do
			value := v1 >= v2
		end

end -- class GE_OPERATOR
