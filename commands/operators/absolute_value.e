indexing
	description:
		"A unary operator that produces the absolute value of its operand"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class ABSOLUTE_VALUE inherit

	UNARY_OPERATOR [REAL, REAL]
		redefine
			operate
		end

creation

	make

feature -- Initialization

	make (o: like operand) is
		require
			not_void: o /= Void
		do
			set_operand (o)
		ensure
			set: operand = o
		end

feature {NONE} -- Basic operations

	operate (v: REAL) is
			-- Null action by default
		do
			if v < 0 then
				value := -v
			else
				value := v
			end
		end

end -- class ABSOLUTE_VALUE
