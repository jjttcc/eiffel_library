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
			arg_not_void_if_mandatory: arg_mandatory implies arg /= Void
		deferred
		end

feature -- Status report

	arg_mandatory: BOOLEAN is
			-- Is the argument to execute mandatory?
		deferred
		end

end -- class COMMAND
