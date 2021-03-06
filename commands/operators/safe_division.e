note
	description:
		"Safe division operator - uses an epsilon value to prevent division %
		%by 0 or by values very close to 0"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class SAFE_DIVISION

inherit

	BINARY_OPERATOR [DOUBLE, DOUBLE]
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

	make (op1: like operand1; op2: like operand2)
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

	epsilon: DOUBLE
			-- Value to use for divide-by-0 detection:
			--    dabs (numerator - 0) < epsilon implies divide_by_0_occurred
			-- where numerator is the result of executing `operand2'

	div_by_0_result: DOUBLE
			-- Value to set the `value' feature to when a
			-- divide-by-0 error occurs

feature -- Status report

	divide_by_0_occurred: BOOLEAN
			-- Did a divide-by-0 error occur?

feature -- Status setting

	set_raise_exception_on_div_by_0 (arg: BOOLEAN)
			-- Set raise_exception_on_div_by_0 to `arg'.
		do
			raise_exception_on_div_by_0 := arg
		ensure
			raise_exception_on_div_by_0_set: raise_exception_on_div_by_0 = arg
		end

	set_epsilon (arg: DOUBLE)
			-- Set epsilon to `arg'.
		do
			epsilon := arg
		ensure
			epsilon_set: epsilon = arg
		end

	set_div_by_0_result (arg: DOUBLE)
			-- Set div_by_0_result to `arg'.
		do
			div_by_0_result := arg
		ensure
			div_by_0_result_set: div_by_0_result = arg
		end

feature -- Basic operations

	execute (arg: ANY)
			-- If a divide-by-0 condition occurs and
			-- raise_exception_on_div_by_0 is True, divide_by_0_occurred will
			-- be True and an exception will be thrown.
		local
			result1: DOUBLE
		do
			-- Save result to avoid possible side effects from executing
			-- operand2.
			operand1.execute (arg)
			result1 := operand1.value
			operand2.execute (arg)
			if dabs (operand2.value - 0) < epsilon then
				divide_by_0_occurred := True
				value := div_by_0_result
				if raise_exception_on_div_by_0 then
					raise ("Divide-by-0 exception")
				end
			else
				divide_by_0_occurred := False
				value := result1 / operand2.value
			end
		ensure then
			div_by_0:
				divide_by_0_occurred = (dabs (operand2.value - 0) < epsilon)
		end

feature {NONE} -- Inapplicable

	operate_unused (a1, a2: DOUBLE) do end

invariant

	dbd_value_result: divide_by_0_occurred implies
		 dabs (value - div_by_0_result) < epsilon
	
end -- class SAFE_DIVISION
