indexing
	description: "Binary operator that implements division"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

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
