note
	description:
		"UNARY_OPERATORs that implement a standard mathematical function"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class UNARY_MATH_OPERATOR inherit

	UNARY_OPERATOR [DOUBLE, DOUBLE]
		undefine
			operate
		end

	DOUBLE_MATH
		export
			{NONE} all
		end

feature -- Initialization

	make (o: like operand)
		require
			not_void: o /= Void
		do
			set_operand (o)
		ensure
			set: operand = o
		end

end
