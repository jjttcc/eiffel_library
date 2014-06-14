note
	description: "Binary operator that implements division"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class DIVISION

inherit

	BINARY_OPERATOR [DOUBLE, DOUBLE]
		redefine
			set_value_to_default
		end

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: DOUBLE)
		do
			value := v1 / v2
		end

	set_value_to_default
		do
			value := 0
		end

end -- class DIVISION
