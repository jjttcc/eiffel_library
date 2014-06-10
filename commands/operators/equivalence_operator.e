note
	description: "Boolean 'equivalence' (<=>) operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class EQUIVALENCE_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN)
		do
			value := v1 = v2
		end

end -- class EQUIVALENCE_OPERATOR
