indexing
	description: "Abstraction for receiving and servicing client requests"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	CLIENT_REQUEST_HANDLER

feature -- Basic operations

	execute is
		local
			cmd: CLIENT_REQUEST_COMMAND
		do
			request_id := -1; session_key := -1; command_argument := Void
			process_request
			if is_logout_request (request_id) then
				-- Logout requests are handled specially - simply remove the
				-- client's session.
				sessions.remove (session_key)
			else
				check
					valid_request_id: not is_logout_request (request_id) and
					request_handlers.has (request_id)
				end
				cmd := request_handlers @ request_id
				setup_command (cmd)
				if
					not is_login_request (request_id) and not request_error
					-- A session is not needed for the login request command,
					-- since it will create one.
				then
					check
						valid_key: sessions.has (session_key)
					end
					cmd.set_session (sessions @ session_key)
				end
				-- `cmd.execute' is expected to handle the error if
				-- `request_error' is true.
				cmd.execute (command_argument)
			end
		end

feature {NONE} -- Hook routines

	process_request is
			-- Input the next client request, blocking if necessary, and split
			-- the received message into `request_id', `session_key',
			-- and `command_argument'.
		require
			components_unset: request_id = -1 and session_key = -1 and
				command_argument = Void
		deferred
		ensure
			reqid_valid: not is_logout_request (request_id) implies
				request_handlers.has (request_id)
			cmdarg_set: not is_logout_request (request_id) and then
				(request_handlers @ request_id).arg_mandatory implies
				command_argument /= Void
			session_key_valid: not is_login_request (request_id) and
				not request_error implies sessions.has (session_key)
		end

	request_error: BOOLEAN is
			-- Did an error occur, such as an invalid request, in
			-- `process_request'?
		deferred
		end

	setup_command (cmd: CLIENT_REQUEST_COMMAND) is
			-- Perform any needed setup on `cmd' before executing it.
		deferred
		end

	is_logout_request (id: INTEGER): BOOLEAN is
			-- Is `id' the request_id for a logout request?
		deferred
		end

	is_login_request (id: INTEGER): BOOLEAN is
			-- Is `id' the request_id for a login request?
		deferred
		end

feature {NONE} -- Implementation

	request_id_and_key_valid: BOOLEAN is
			-- Is the combination of `request_id' and `session_key' valid?
		do
			if
				not sessions.has (session_key) and
				not is_login_request (request_id)
			then
				Result := false
			else
				Result := true
			end
		end

	request_handlers: HASH_TABLE [CLIENT_REQUEST_COMMAND, INTEGER]
			-- Handlers of client requests received via io_medium, keyed
			-- by `request_id'

	session_key: INTEGER
			-- Session key for last client request, extracted
			-- by `process_request'

	request_id: INTEGER
			-- ID of last client request, extracted
			-- by `process_request'

	command_argument: ANY
			-- Argument for the current client request command, extracted
			-- by `process_request'

	sessions: HASH_TABLE [SESSION, INTEGER] is
			-- Existing client sessions, keyed by `session_key'
		deferred
		end

invariant

	request_handlers_initialized: request_handlers /= Void
	sessions_not_void: sessions /= Void

end -- class CLIENT_REQUEST_HANDLER
