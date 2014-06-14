note
	description: "Binary operator that implements subtraction"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class SUBTRACTION

inherit

 	BINARY_OPERATOR [DOUBLE, DOUBLE]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: DOUBLE)
		do
			value := v1 - v2
		end

end -- class SUBTRACTION
