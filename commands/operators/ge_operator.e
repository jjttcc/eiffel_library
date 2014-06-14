note
	description: "Greater-than-or-equal-to operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

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
