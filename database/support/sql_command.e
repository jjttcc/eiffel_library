note
	description: "Executable SQL commands"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 2004: Jim Cochrane - License to be determined."

deferred class SQL_COMMAND [G] inherit

	RESULT_COMMAND [G]

	EVENT_SUPPLIER

feature -- Status report

	arg_mandatory: BOOLEAN = False

	execution_succeeded: BOOLEAN
			-- Did the last call to `execute' succeed?

feature -- Basic operations

	execute (arg: ANY)
		do
			execution_succeeded := do_execute
			notify_clients
		end

feature {NONE} -- Hook routines

	do_execute: BOOLEAN
			-- Perform the execution, returning whether the execution
			-- succeeded.
		deferred
		end

end
