indexing
	description: "Boolean 'implication' (=>) operator"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class IMPLICATION_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN) is
		do
			value := v1 implies v2
		end

end -- class IMPLICATION_OPERATOR
