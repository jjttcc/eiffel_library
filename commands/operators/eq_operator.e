indexing
	description: "Equal-to operator.  Returns true if the absolute value of %
	%the difference of the two operands is less than epsilon."
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class EQ_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, REAL]
		rename
			make as bo_make
		export {NONE}
			bo_make
		end

	MATH_CONSTANTS
		rename
			Epsilon as Default_epsilon
		end

creation

	make

feature {NONE} -- Initialization

	make (op1: like operand1; op2: like operand2) is
			-- Set the operands to the specified values and initialize epsilon.
		require
			not_void: op1 /= Void and op2 /= Void
		do
		    operand1 := op1
		    operand2 := op2
			epsilon := Default_epsilon
		ensure
			are_set: operand1 = op1 and operand2 = op2
			not_void: operand1 /= Void and operand2 /= Void
		end

feature -- Access

	epsilon: REAL

feature -- Status setting

	set_epsilon (arg: REAL) is
			-- Set epsilon to `arg'.
		require
			arg /= Void
		do
			epsilon := arg
		ensure
			epsilon_set: epsilon = arg and epsilon /= Void
		end

feature {NONE} -- Hook routine implementation

	operate (v1, v2: REAL) is
		do
			value := rabs (v1 - v2) < epsilon
		end

end -- class EQ_OPERATOR
