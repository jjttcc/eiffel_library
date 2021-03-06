note
	description: "Boolean 'xor' operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class XOR_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN)
		do
			value := not (v1 = v2)
		end

end -- class XOR_OPERATOR
