indexing
	description: "Executable SQL commands"
	date: "$Date$";
	revision: "$Revision$"

deferred class SQL_COMMAND [G] inherit

	RESULT_COMMAND [G]

	EVENT_SUPPLIER

feature -- Status report

	arg_mandatory: BOOLEAN is False

	execution_succeeded: BOOLEAN
			-- Did the last call to `execute' succeed?

feature -- Basic operations

	execute (arg: ANY) is
		do
			execution_succeeded := do_execute
			notify_clients
		end

feature {NONE} -- Hook routines

	do_execute: BOOLEAN is
			-- Perform the execution, returning whether the execution
			-- succeeded.
		deferred
		end

end
