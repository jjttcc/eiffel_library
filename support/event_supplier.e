indexing
	description: "Suppliers for EVENT_CLIENTs"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 2003: Jim Cochrane - %
		%License to be determined"

deferred class EVENT_SUPPLIER

feature -- Access

	action_code: INTEGER
			-- The action code specified by the last call to `register_client'

	client: EVENT_CLIENT

feature -- Client services

	register_client (c: EVENT_CLIENT; actn_code: INTEGER) is
			-- Register `c' as a "session-location" client with `actn_code'
			-- spcifying what action for the client to take on callback.
		require
			arg_exists: c /= Void
		do
			client := c
			action_code := actn_code
		ensure
			client_set: client = c
			code_set: action_code = actn_code
		end

end
