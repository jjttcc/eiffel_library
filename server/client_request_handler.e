note
	description: "Abstraction for receiving and servicing client requests"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	CLIENT_REQUEST_HANDLER

feature -- Access

	command_type_anchor: CLIENT_REQUEST_COMMAND
		deferred
		end

feature -- Basic operations

	execute
		local
			cmd: like command_type_anchor
		do
print("[14.05-testing]: CLIENT_REQUEST_HANDLER.execute called%N")
			if initialization_needed then
				request_id := Void; command_argument := Void
			end
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
					valid_request_id: (is_logout_request (request_id) implies
						not handle_logout_separately) and
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
				-- `request_error' is True.
				cmd.execute (command_argument)
			end
		end

feature {NONE} -- Hook routines

	sessions_used: BOOLEAN
			-- Is session management used in this implementation?
		once
			Result := True
		end

	process_request
			-- Input the next client request, blocking if necessary, and use
			-- it to set `request_id', `command_argument', and, if
			-- `sessions_used', `session'.
		require
			components_initialized_if_needed: initialization_needed implies
				request_id = Void and command_argument = Void
		deferred
		ensure
			reqid_legal: not is_logout_request (request_id) implies
				request_handlers.has (request_id)
			cmdarg_set: not is_logout_request (request_id) and then
				(request_handlers @ request_id).arg_mandatory implies
				command_argument /= Void
			session_valid: session_valid
		end

	handle_logout_separately: BOOLEAN
		once
			Result := True
		end

	initialization_needed: BOOLEAN
			-- Is initialization needed before calling `process_request'?
		once
			Result := True
		end

	handle_logout
			-- Do any necessary handling of a logout request.
		require
			logout: is_logout_request (request_id)
		do
		end

	request_error: BOOLEAN
			-- Did an error occur, such as an invalid request, in
			-- `process_request'?
		deferred
		end

	setup_command (cmd: like command_type_anchor)
			-- Perform any needed setup on `cmd' before executing it.
		do
		end

	cleanup_session
			-- Perform needed cleanup on `session'.
		require
			valid_session: session /= Void
		do
		end

	is_logout_request (id: like request_id): BOOLEAN
			-- Is `id' the request_id for a logout request?
		deferred
		end

	is_login_request (id: like request_id): BOOLEAN
			-- Is `id' the request_id for a login request?
		deferred
		end

feature {NONE} -- Implementation

	session_valid: BOOLEAN
			-- Is `session' valid?
		do
			Result := sessions_used and
				not is_login_request (request_id) and
				not request_error implies session /= Void
		ensure
			definition: Result = (sessions_used and
				not is_login_request (request_id) and
				not request_error implies session /= Void)
		end

	request_handlers: HASH_TABLE [like command_type_anchor, HASHABLE]
			-- Handlers of client requests, keyed by `request_id'

	request_id: HASHABLE
			-- ID of last client request, extracted
			-- by `process_request'

	command_argument: ANY
			-- Argument for the current client request command, extracted
			-- by `process_request'

	session: SESSION
			-- The current log-in session
		do
			-- Needs to be redefined if `sessions_used' is True.
		end

invariant

	request_handlers_initialized: request_handlers /= Void

end -- class CLIENT_REQUEST_HANDLER
