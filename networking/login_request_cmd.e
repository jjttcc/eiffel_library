indexing
	description: "A command that responds to a client log-in request"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class LOGIN_REQUEST_CMD inherit

	IO_BASED_CLIENT_REQUEST_COMMAND

feature -- Status report

	error_occurred: BOOLEAN
			-- Did an error occur the last time `execute' was called?

	last_error: STRING
			-- Description of last error

feature {NONE} -- Basic operations

	do_execute (msg: STRING) is
			-- Create a new session and add it to `sessions', process `msg',
			-- and send a unique session ID to the requesting client.
			-- If a protocol error is encountered in `msg', an error
			-- status and an error message is sent to the client instead
			-- of a session ID.
		local
			session_id: INTEGER
		do
			error_occurred := False
			session_id := new_key
			create_session
			pre_process_session
			if not msg.is_empty then
				process (msg)
			end
			if error_occurred then
				report_error (error, <<last_error>>)
				-- Don't add the new session.
			else
				put_ok
				put (session_id.out)
				put_session_state
				put (eom)
				add_session (session_id)
				post_process_session
			end
		ensure then
			one_more_session: not error_occurred implies
				sessions.count = old sessions.count + 1
			new_session: not error_occurred implies
				session /= Void and sessions.has_item (session)
		end

	add_session (session_id: INTEGER) is
			-- Add `session' to `sessions'.
		require
			session_exists: session /= Void
		do
			sessions.extend (session, session_id)
		ensure
			one_more_session: not error_occurred implies
				sessions.count = old sessions.count + 1
			new_session: not error_occurred implies
				session /= Void and sessions.has_item (session)
		end

feature {NONE} -- Hook routines

	pre_process_session is
			-- Perform any needed processing before adding `session'
			-- to `sessions'.
		require
			session_exists: session /= Void
		do
			-- Null routine - redefine if needed.
		end

	post_process_session is
			-- Perform any needed processing after adding `session'
			-- to `sessions'.
		require
			session_exists: session /= Void
		do
			-- Null routine - redefine if needed.
		end

	process (message: STRING) is
			-- Process `message' received from the client.
		require
			message_exists: message /= Void and not message.is_empty
		deferred
		end

	put_session_state is
			-- Send any needed "session state" information (formatted according
			-- to the client/server communication protocol) to the client.
		require
			session_exists: session /= Void
		do
			-- Null routine - redefine if needed.
		end

	sessions: HASH_TABLE [SESSION, INTEGER] is
			-- Registered client sessions
		deferred
		end

	create_session is
			-- Create `session'.
		deferred
		ensure
			session_exists: session /= Void
		end

feature {NONE} -- Implementation

	new_key: INTEGER is
			-- A new key not currently used in `sessions'
		local
			keys: ARRAY [INTEGER]
			i: INTEGER
		do
			keys := sessions.current_keys
			if keys.count = 0 then
				Result := 1
			else
				-- Set Result to one greater than the highest key value.
				from
					i := 1
				until
					i > keys.count
				loop
					if keys @ i > Result then
						Result := keys @ i
					end
					i := i + 1
				end
				Result := Result + 1
			end
		ensure
			new_key: not sessions.has (Result)
		end

invariant

	sessions_exist: sessions /= Void

end
