indexing
	description:
		"A command that plays the role of client of a BOOLEAN_OPERATOR by, %
		%in its execute routine, providing two operands for the %
		%BOOLEAN_OPERATOR and, when the operator evaluates to true, %
		%executing a 'true command', and when false, executing a 'false %
		%command'."
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class BOOLEAN_CLIENT inherit

	NUMERIC_COMMAND -- ???!!!

creation

	make

feature -- Initialization

	make (bool_oper: like boolean_operator; bool_opnd1, bool_opnd2:
			like bool_operand1; true_command, false_command: like true_cmd) is
		require
			args_not_void: bool_oper /= Void and true_command /= Void and
				false_command /= Void and bool_opnd1 /= Void and
				bool_opnd2 /= Void
		do
			boolean_operator := bool_oper
			true_cmd := true_command
			false_cmd := false_command
			bool_operand1 := bool_opnd1
			bool_operand2 := bool_opnd2
		ensure
			bool_op_set:
					boolean_operator = bool_oper and boolean_operator /= Void
			true_cmd_set: true_cmd = true_command and true_cmd /= Void
			false_cmd_set: false_cmd = false_command and false_cmd /= Void
			operands_set: bool_operand1 = bool_opnd1 and
							bool_operand2 = bool_opnd2
		end

feature -- Access

	boolean_operator: BOOLEAN_OPERATOR [COMPARABLE]
			-- Operator used to compare two values

	bool_operand1: NUMERIC_COMMAND
			-- Command whose (COMPARABLE) value will be used as
			-- `boolean_operator's first operand

	bool_operand2: NUMERIC_COMMAND
			-- Command whose (COMPARABLE) value will be used as
			-- `boolean_operator's second operand

	true_cmd: NUMERIC_COMMAND
			-- Command that extracts the value to use if boolean_operator
			-- evaluates as true

	false_cmd: NUMERIC_COMMAND
			-- Command that extracts the value to use if boolean_operator
			-- evaluates as false

feature -- Status report

	arg_mandatory: BOOLEAN is
		do
			Result := boolean_operator.arg_mandatory or
				true_cmd.arg_mandatory or false_cmd.arg_mandatory or
				bool_operand1.arg_mandatory or bool_operand2.arg_mandatory
		end

feature -- Status setting

	set_boolean_operator (arg: BOOLEAN_OPERATOR [COMPARABLE]) is
			-- Set boolean_operator to `arg'.
		require
			arg /= Void
		do
			boolean_operator := arg
		ensure
			boolean_operator_set: boolean_operator = arg and
									boolean_operator /= Void
		end

	set_true_cmd (arg: BASIC_NUMERIC_COMMAND) is
			-- Set true_cmd to `arg'.
		require
			arg /= Void
		do
			true_cmd := arg
		ensure
			true_cmd_set: true_cmd = arg and
								true_cmd /= Void
		end

	set_false_cmd (arg: BASIC_NUMERIC_COMMAND) is
			-- Set false_cmd to `arg'.
		require
			arg /= Void
		do
			false_cmd := arg
		ensure
			false_cmd_set: false_cmd = arg and
									false_cmd /= Void
		end

feature -- Basic operations

	execute (arg: ANY) is
		do
			bool_operand1.execute (arg)
			bool_operand2.execute (arg)
			boolean_operator.set_operands (bool_operand1.value,
											bool_operand2.value)
			boolean_operator.execute (arg)
			if boolean_operator.value then
				true_cmd.execute (arg)
				value := true_cmd.value
			else
				false_cmd.execute (arg)
				value := false_cmd.value
			end
		end

invariant

	boolean_operator_not_void: boolean_operator /= Void
	bool_operand1_not_void: bool_operand1 /= Void
	bool_operand2_not_void: bool_operand2 /= Void
	true_cmd_not_void: true_cmd /= Void
	false_cmd_not_void: false_cmd /= Void

end -- class BOOLEAN_CLIENT
