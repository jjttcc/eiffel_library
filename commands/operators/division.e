indexing
	description: "Binary operator that implements division"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class DIVISION

inherit

	BINARY_OPERATOR [REAL, REAL]
		redefine
			set_value_to_default
		end

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: REAL) is
		do
			value := v1 / v2
		end

	set_value_to_default is
		do
			value := 0
		end

end -- class DIVISION
