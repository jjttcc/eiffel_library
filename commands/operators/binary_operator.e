indexing
	description: "Abstraction for an operator that operates on two operands."

deferred class BINARY_OPERATOR

inherit

	NUMERIC_COMMAND

feature -- Access

	operand1: NUMERIC_COMMAND
			-- the first operand to be operated on

	operand2: NUMERIC_COMMAND
			-- the second operand to be operated on

feature {FINANCE_ROOT} -- Export to test clas for now.

	set_operands (op1: NUMERIC_COMMAND; op2: NUMERIC_COMMAND) is
			-- Set the operands to the specified values.
		require
			not_void: op1 /= Void and op2 /= Void
		do
		    operand1 := op1
		    operand2 := op2
		ensure
			are_set: operand1 = op1 and operand2 = op2
		end

end -- class BINARY_OPERATOR
