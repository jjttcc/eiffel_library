indexing
	description: "Equal-to operator"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class EQ_OPERATOR inherit

	BOOLEAN_OPERATOR

creation

	make

feature {NONE} -- Implementation

	operation (v1, v2: REAL): BOOLEAN is
		do
			Result := v1 = v2
		end

end -- class EQ_OPERATOR
