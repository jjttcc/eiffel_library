indexing
	description:
		"A RESULT_COMMAND that takes an operand (also of type RESULT_COMMAND) %
		%and operates on its result"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class UNARY_OPERATOR [G] inherit

	RESULT_COMMAND [G]
		redefine
			initialize
		end

feature -- Initialization

	initialize (arg: ANY) is
		do
			operand.initialize (arg)
		end

feature -- Access

	operand: RESULT_COMMAND [G]

feature -- Status report

	arg_mandatory: BOOLEAN is
		do
			Result := operand.arg_mandatory
		end

feature -- Status setting

	set_operand (arg: like operand) is
			-- Set operand to `arg'.
		require
			arg /= Void
		do
			operand := arg
		ensure
			operand_set: operand = arg and operand /= Void
		end

invariant

	op_not_void: operand /= Void

end -- class UNARY_OPERATOR
