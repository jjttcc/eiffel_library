indexing
	description:
		"A numeric command that uses an operator to perform its processing"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class OPERATOR_COMMAND inherit

	NUMERIC_COMMAND

feature -- Access

	operator: NUMERIC_COMMAND

feature -- Status report

	arg_mandatory: BOOLEAN is
		do
			Result := operator.arg_mandatory
		ensure then
			operator_dependency: operator.arg_mandatory implies Result
		end

feature -- Status setting

	set_operator (arg: NUMERIC_COMMAND) is
			-- Set operator to `arg'.
		require
			arg /= Void
		do
			operator := arg
		ensure
			operator_set: operator = arg and operator /= Void
		end

invariant

	op_not_void: operator /= Void

end -- class OPERATOR_COMMAND
