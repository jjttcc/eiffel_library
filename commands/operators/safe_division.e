indexing
	description:
		"Safe division operator - uses an epsilon value to prevent division %
		%by 0 or by values very close to 0"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class SAFE_DIVISION

inherit

	BINARY_OPERATOR [REAL, REAL]
		rename
			make as bo_make_unused, operate as operate_unused
		export
			{NONE} bo_make_unused
		redefine
			execute
		end

	MATH_CONSTANTS
		rename
			epsilon as initial_epsilon
		export
			{NONE} all
			{ANY} initial_epsilon
		end

creation

	make

feature -- Initialization

	make (op1: like operand1; op2: like operand2) is
			-- Set the operands to the specified values.
		require
			not_void: op1 /= Void and op2 /= Void
		do
		    operand1 := op1
		    operand2 := op2
			epsilon := initial_epsilon
		ensure
			are_set: operand1 = op1 and operand2 = op2
			not_void: operand1 /= Void and operand2 /= Void
			no_exceptions: not raise_exception_on_div_by_0
			default_result_0: div_by_0_result = 0
			-- epsilon = initial_epsilon
		end

feature -- Access

	raise_exception_on_div_by_0: BOOLEAN
			-- Will an exception be raised when a divide-by-0 operation is
			-- detected?

	epsilon: REAL
			-- Value to use for divide-by-0 detection:
			--    rabs (numerator - 0) < epsilon implies divide_by_0_occurred
			-- where numerator is the result of executing `operand2'

	div_by_0_result: REAL
			-- Value to set the `value' feature to when a
			-- divide-by-0 error occurs

feature -- Status report

	divide_by_0_occurred: BOOLEAN
			-- Did a divide-by-0 error occur?

feature -- Status setting

	set_raise_exception_on_div_by_0 (arg: BOOLEAN) is
			-- Set raise_exception_on_div_by_0 to `arg'.
		require
			arg_not_void: arg /= Void
		do
			raise_exception_on_div_by_0 := arg
		ensure
			raise_exception_on_div_by_0_set: raise_exception_on_div_by_0 = arg
		end

	set_epsilon (arg: REAL) is
			-- Set epsilon to `arg'.
		require
			arg_not_void: arg /= Void
		do
			epsilon := arg
		ensure
			epsilon_set: epsilon = arg
		end

	set_div_by_0_result (arg: REAL) is
			-- Set div_by_0_result to `arg'.
		require
			arg_not_void: arg /= Void
		do
			div_by_0_result := arg
		ensure
			div_by_0_result_set: div_by_0_result = arg
		end

feature -- Basic operations

	execute (arg: ANY) is
			-- If a divide-by-0 condition occurs and
			-- raise_exception_on_div_by_0 is true, divide_by_0_occurred will
			-- be true and an exception will be thrown.
		local
			result1: REAL
		do
			-- Save result to avoid possible side effects from executing
			-- operand2.
			operand1.execute (arg)
			result1 := operand1.value
			operand2.execute (arg)
			if rabs (operand2.value - 0) < epsilon then
				divide_by_0_occurred := true
				value := div_by_0_result
				if raise_exception_on_div_by_0 then
					raise ("Divide-by-0 exception")
				end
			else
				divide_by_0_occurred := false
				value := result1 / operand2.value
			end
		ensure then
			div_by_0:
				divide_by_0_occurred = (rabs (operand2.value - 0) < epsilon)
		end

feature {NONE} -- Inapplicable

	operate_unused (a1, a2: REAL) is do end

invariant

	dbd_value_result: divide_by_0_occurred implies
		 rabs (value - div_by_0_result) < epsilon
	
end -- class SAFE_DIVISION
