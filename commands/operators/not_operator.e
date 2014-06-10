note
	description:
		"A unary operator that provides the logical negation of its %
		%operand's value"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class NOT_OPERATOR inherit

	UNARY_OPERATOR [BOOLEAN, BOOLEAN]
		redefine
			operate
		end

creation

	make

feature -- Initialization

	make (o: like operand)
		require
			not_void: o /= Void
		do
			set_operand (o)
		ensure
			set: operand = o
		end

feature {NONE} -- Basic operations

	operate (v: BOOLEAN)
			-- Null action by default
		do
			value := not v
		end

end -- class NOT_OPERATOR
