indexing
	description:
		"UNARY_OPERATORs that implement a standard mathematical function"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class UNARY_MATH_OPERATOR inherit

	UNARY_OPERATOR [REAL, REAL]
		undefine
			operate
		end

	SINGLE_MATH
		export
			{NONE} all
		end

feature -- Initialization

	make (o: like operand) is
		require
			not_void: o /= Void
		do
			set_operand (o)
		ensure
			set: operand = o
		end

end
