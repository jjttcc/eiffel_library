indexing
	description:
		"A unary operator that provides the logical negation of its %
		%operand's value"
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class NOT_OPERATOR inherit

	UNARY_OPERATOR [BOOLEAN, BOOLEAN]
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

	operate (v: BOOLEAN) is
			-- Null action by default
		do
			value := not v
		end

end -- class NOT_OPERATOR
