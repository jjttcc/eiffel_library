indexing
	description:
		"Abstraction for a command that operates on two operands.  G is the %
		%type of the 'value' query and H is the type of the 'value' query %
		%for the two operands."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

deferred class BINARY_OPERATOR [G, H] inherit

	RESULT_COMMAND [G]
		redefine
			initialize
		end

	EXCEPTIONS
		export {NONE}
			all
		end

feature -- Initialization

	set_operands, make (op1: like operand1; op2: like operand2) is
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

	initialize (arg: ANY) is
			-- Call initialize with arg on operand1 and operand2.
		do
			operand1.initialize (arg)
			operand2.initialize (arg)
		end

feature -- Access

	operand1: RESULT_COMMAND [H]
			-- The first operand to be operated on

	operand2: RESULT_COMMAND [H]
			-- The second operand to be operated on

feature -- Status report

	arg_mandatory: BOOLEAN is
		do
			Result := operand1.arg_mandatory or operand2.arg_mandatory
		end

feature -- Basic operations

	execute (arg: ANY) is
			-- A system exception may occur (most likely caused by division
			-- by 0) during execution of this feature.  In this case,
			-- the exception is caught and `value' is set to a default.
		local
			result1: H
			exception_occurred: BOOLEAN
		do
			if not exception_occurred then
				operand1.execute (arg)
				-- Save result to avoid possible side effects from executing
				-- operand2.
				result1 := operand1.value
				operand2.execute (arg)
				operate (result1, operand2.value)
			else
				set_value_to_default
			end
		rescue
			-- The most likely (perhaps only possible) exception is
			-- division by 0 in the operate feature, when the run-time
			-- type is DIVISION.
			exception_occurred := true
			retry
		end

feature {NONE} -- Hook routines

	operate (v1, v2: H) is
		require
			not_void: v1 /= Void and v2 /= Void
		deferred
		ensure
			value_not_void: value /= Void
		end

	set_value_to_default is
			-- Set `value' to a default value to handle exception condition.
		do
			value := value.default
		end

end -- class BINARY_OPERATOR
