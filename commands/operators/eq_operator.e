note
	description: "Equal-to operator.  Returns True if the absolute value of %
	%the difference of the two operands is less than epsilon."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class EQ_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, DOUBLE]
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

	make (op1: like operand1; op2: like operand2)
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

	epsilon: DOUBLE

feature -- Status setting

	set_epsilon (arg: DOUBLE)
			-- Set epsilon to `arg'.
		do
			epsilon := arg
		ensure
			epsilon_set: epsilon = arg
		end

feature {NONE} -- Hook routine implementation

	operate (v1, v2: DOUBLE)
		do
			value := dabs (v1 - v2) < epsilon
		end

end -- class EQ_OPERATOR
