indexing
	description: "Boolean 'and' operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class AND_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN) is
		do
			value := v1 and v2
		end

end -- class AND_OPERATOR
