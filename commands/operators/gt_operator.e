indexing
	description: "Greater-than operator"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

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
