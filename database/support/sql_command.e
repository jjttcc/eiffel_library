indexing
	description: "Executable SQL commands"
	date: "$Date$";
	revision: "$Revision$"

deferred class SQL_COMMAND [G] inherit

	RESULT_COMMAND [G]

	EVENT_SUPPLIER

feature -- Access

	database_handle: GLOBAL_DATABASE_FACILITIES

feature -- Status report

	arg_mandatory: BOOLEAN is False

	execution_succeeded: BOOLEAN
			-- Did the last call to `execute' succeed?

feature -- Element change

	set_database_handle (arg: GLOBAL_DATABASE_FACILITIES) is
			-- Set `database_handle' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			database_handle := arg
		ensure
			database_handle_set: database_handle = arg and
				database_handle /= Void
		end

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

invariant

	database_handle_exists: database_handle /= Void

end
