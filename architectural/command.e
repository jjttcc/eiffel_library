indexing
	description: "Basic abstraciont for an executable command";
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
			-- Execute the command with the specified (optional) argument.
		deferred
		end

end -- class COMMAND
