indexing
	description:
		"Basic abstraction for an executable command"
	date: "$Date$";
	revision: "$Revision$"

deferred class 

	COMMAND

feature -- Initialization

	initialize (arg: ANY) is
			-- Perform initialization, obtaining any needed values from arg.
			-- Null action by default - descendants redefine as needed.
		do
		end

feature -- Basic operations

	execute (arg: ANY) is
			-- Execute the command with the specified argument.
		require
			arg_not_void_if_used: arg_used implies arg /= Void
			execute_precondition: execute_precondition
		deferred
		end

feature -- Status report

	arg_used: BOOLEAN is
		deferred
		end

	execute_precondition: BOOLEAN is
			-- Precondition for execute function
		deferred
		end

end -- class COMMAND
