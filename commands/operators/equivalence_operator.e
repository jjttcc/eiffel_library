indexing
	description: "Boolean 'equivalence' (<=>) operator"
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class EQUIVALENCE_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN) is
		do
			value := v1 = v2
		end

end -- class EQUIVALENCE_OPERATOR
