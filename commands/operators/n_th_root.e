indexing
	description: "Binary operator whose result is the n-th root (specified %
		%by the right operand) of its left operand"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class N_TH_ROOT

inherit

	BINARY_OPERATOR [REAL, REAL]

creation

	make

feature {NONE} -- Hook routine implementation

	operate (v1, v2: REAL) is
		do
			value := v1 ^ (1 / v2)
		end

end -- class N_TH_ROOT
