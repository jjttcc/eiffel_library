note
	description: "Executable SQL commands"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
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
