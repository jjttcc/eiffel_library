indexing
	description: "Abstraction for a command that operates on two operands"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class BINARY_OPERATOR [G, H] inherit

	COMMAND

feature -- Access

	operand1: G
			-- The first operand to be operated on

	operand2: G
			-- The second operand to be operated on

	value: H is
			-- The value resulting from calling execute
		deferred
		end

feature

	set_operands, make_with_operands (op1: like operand1;
										op2: like operand2) is
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
