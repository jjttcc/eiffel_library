indexing
	description: "Boolean 'xor' operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class XOR_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN) is
		do
			value := not (v1 = v2)
		end

end -- class XOR_OPERATOR
