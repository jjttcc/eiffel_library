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
			arg_not_void: arg /= Void
		deferred
		end

end -- class COMMAND
