indexing
	description:
		"A unary operator that produces the absolute value of its operand"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

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
