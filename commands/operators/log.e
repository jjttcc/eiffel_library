indexing
	description: "Natural logarithm operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class LOG inherit

	UNARY_OPERATOR [REAL, REAL]
		redefine
			operate
		end

	SINGLE_MATH
		export
			{NONE} all
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
			value := log (v)
		end

end -- class LOG