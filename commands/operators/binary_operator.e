indexing
	description: "Abstraction for an operator that operates on two operands."
	date: "$Date$";
	revision: "$Revision$"

deferred class BINARY_OPERATOR

inherit

	NUMERIC_COMMAND
		redefine
			initialize
		end

feature -- Initialization

	initialize (arg: ANY) is
		do
			check operand1 /= Void and operand2 /= Void end
			operand1.initialize (arg)
			operand2.initialize (arg)
		end

feature -- Access

	operand1: NUMERIC_COMMAND
			-- the first operand to be operated on

	operand2: NUMERIC_COMMAND
			-- the second operand to be operated on

feature {TEST_FUNCTION_FACTORY, MARKET_FUNCTION} -- !!!Check export clause

	set_operands (op1: NUMERIC_COMMAND; op2: NUMERIC_COMMAND) is
			-- Set the operands to the specified values.
		require
			not_void: op1 /= Void and op2 /= Void
		do
		    operand1 := op1
		    operand2 := op2
		ensure
			are_set: operand1 = op1 and operand2 = op2
			not_void: operand1 /= Void and operand2 /= Void
		end

end -- class BINARY_OPERATOR
