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
			request_id := -1; command_argument := Void
			process_request
			if handle_logout_separately and is_logout_request (request_id) then
				handle_logout
				if sessions_used and session /= Void then
					-- Logout requests are handled specially - simply clean
					-- up the client's session.
					cleanup_session
				end
			else
				check
					valid_request_id: not is_logout_request (request_id) and
					request_handlers.has (request_id)
				end
				cmd := request_handlers @ request_id
				setup_command (cmd)
				if
					sessions_used and
					not is_login_request (request_id) and not request_error
					-- A session is not needed for the login request command,
					-- since it will create one.
				then
					check
						valid_session: session /= Void
					end
					cmd.set_session (session)
				end
				-- `cmd.execute' is expected to handle the error if
				-- `request_error' is true.
				cmd.execute (command_argument)
			end
		end

feature {NONE} -- Hook routines

	sessions_used: BOOLEAN is
			-- Is session management used in this implementation?
		once
			Result := True
		end

	process_request is
			-- Input the next client request, blocking if necessary, and use
			-- it to set `request_id', `command_argument', and, if
			-- `sessions_used', `session'.
		require
			components_unset: request_id = -1 and command_argument = Void
		deferred
		ensure
			reqid_legal: not is_logout_request (request_id) implies
				request_handlers.has (request_id)
			cmdarg_set: not is_logout_request (request_id) and then
				(request_handlers @ request_id).arg_mandatory implies
				command_argument /= Void
			session_valid: session_valid
		end

	handle_logout_separately: BOOLEAN is
		once
			Result := True
		end

	handle_logout is
			-- Do any necessary handling of a logout request.
		require
			logout: is_logout_request (request_id)
		do
		end

	request_error: BOOLEAN is
			-- Did an error occur, such as an invalid request, in
			-- `process_request'?
		deferred
		end

	setup_command (cmd: CLIENT_REQUEST_COMMAND) is
			-- Perform any needed setup on `cmd' before executing it.
		do
		end

	cleanup_session is
			-- Perform needed cleanup on `session'.
		require
			valid_session: session /= Void
		do
		end

	is_logout_request (id: like request_id): BOOLEAN is
			-- Is `id' the request_id for a logout request?
		deferred
		end

	is_login_request (id: like request_id): BOOLEAN is
			-- Is `id' the request_id for a login request?
		deferred
		end

feature {NONE} -- Implementation

	session_valid: BOOLEAN is
			-- Is `session' valid?
		do
			Result := sessions_used and
				not is_login_request (request_id) and
				not request_error implies session /= Void
		ensure
			definition: sessions_used and
				not is_login_request (request_id) and
				not request_error implies session /= Void
		end

	request_handlers: HASH_TABLE [CLIENT_REQUEST_COMMAND, HASHABLE]
			-- Handlers of client requests, keyed by `request_id'

	request_id: HASHABLE
			-- ID of last client request, extracted
			-- by `process_request'

	command_argument: ANY
			-- Argument for the current client request command, extracted
			-- by `process_request'

	session: SESSION is
			-- The current log-in session
		do
			-- Needs to be redefined if `sessions_used' is True.
		end

invariant

	request_handlers_initialized: request_handlers /= Void

end -- class CLIENT_REQUEST_HANDLER
