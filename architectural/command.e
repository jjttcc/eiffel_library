indexing
	description: "";
	date: "$Date$";
	revision: "$Revision$"

deferred class 

	COMMAND

feature -- Basic operations

	execute (arg: ANY) is
			-- Execute the command with the specified (optional) argument.
		require
			valid_state
		deferred
		ensure
			valid_state
		end

feature -- Status report

	valid_state: BOOLEAN is
			-- Is Current in a valid state?
			-- Default to true - descendants redefine as necessary.
		do
			Result := true
		end

end -- class COMMAND
