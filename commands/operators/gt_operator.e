indexing
	description: "Greater-than operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class GT_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, REAL]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: REAL) is
		do
			value := v1 > v2
		end

end -- class GT_OPERATOR
