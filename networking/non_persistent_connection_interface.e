indexing
	description: "Interface for a %"non-persistent%" connection"
	author: "Jim Cochrane"
	date: "$Date$";
	note: "It is expected that, before `execute' is called, the first %
		%character of the input of io_medium has been read."
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class NON_PERSISTENT_CONNECTION_INTERFACE inherit

	CONNECTION_INTERFACE

	CLIENT_REQUEST_HANDLER
		rename
			command_argument as message_body
		redefine
			message_body, setup_command,
			cleanup_session, session
		end

feature -- Access

	io_medium: SOCKET

	sessions: HASH_TABLE [SESSION, INTEGER] is
			-- Registered GUI Client sessions
		deferred
		end

feature -- Element change

	set_io_medium (arg: like io_medium) is
			-- Set io_medium to `arg'.
		require
			arg_not_void: arg /= Void
		do
			io_medium := arg
			post_process_io_medium
		ensure
			io_medium_set: io_medium = arg and io_medium /= Void
		end

feature {NONE} -- Hook routines

	post_process_io_medium is
			-- Perform any postprocessing needed after setting `io_medium'.
		deferred
		end

	end_of_message (c: CHARACTER): BOOLEAN is
			-- Does `c' designate the end of a message?
		deferred
		end

	Message_field_separator: STRING is
			-- Field separator used to parse `message_body'
		deferred
		end

	Message_record_separator: STRING is
			-- Record separator used to parse `message_body'
		deferred
		end

	Logout_request: INTEGER is
			-- Code for a logout request
		deferred
		end

	Login_request: INTEGER is
			-- Code for a login request
		deferred
		end

	Error: INTEGER is
			-- Code indicating an error occurred while processing the
			-- last client request
		deferred
		end

	log_error (msg: STRING) is
			-- Log `msg' as an error.
		deferred
		end

feature {NONE} -- Hook routines implementations

	setup_command (cmd: IO_BASED_CLIENT_REQUEST_COMMAND) is
		do
			cmd.set_output_medium (io_medium)
		end

	request_error: BOOLEAN is
		do
			Result := request_id = Error
		end

	session: SESSION is
		do
			if sessions.has (session_key) then
				Result := sessions @ session_key
			end
		end

	cleanup_session is
		do
			sessions.remove (session_key)
		end

	process_request is
			-- Input the next client request, blocking if necessary, and split
			-- the received message into `request_id', `session_key',
			-- and `message_body'.
		local
			s, number: STRING
			i, j, loop_count: INTEGER
		do
			create s.make (0)
			from
				loop_count := 0
			until
				end_of_message (io_medium.last_character) or not
				io_medium.readable or loop_count > Maximum_client_message_size
			loop
				s.extend (io_medium.last_character)
				io_medium.read_character
				loop_count := loop_count + 1
			end
			if s.is_empty then
				i := 0
			else
				i := s.substring_index (Message_field_separator, 1)
			end
			if i <= 1 then
				request_id := Error
				report_error ("Invalid message format: " + s, Void, Void)
			elseif not end_of_message (io_medium.last_character) then
				s.extend (io_medium.last_character)
				request_id := Error
				report_error ("End of message string not received with:%N" + s,
					Void, Void)
			else
				-- Extract the request ID.
				number := s.substring (1, i - 1)
				if not number.is_integer then
					report_error ("Request ID is not a valid integer: " +
						number, Void, Void)
					request_id := Error
				elseif
					not request_handlers.has (number.to_integer) and
					number.to_integer /= Logout_request
				then
					report_error ("Invalid request ID: " + number, Void, Void)
					request_id := Error
				else
					request_id := number.to_integer
					if s.count < i + Message_field_separator.count then
						j := 0
					else
						j := s.substring_index (Message_field_separator,
								i + Message_field_separator.count)
					end
					if j = 0 then
						report_error ("Invalid message format: " + s,
							Void, Void)
						request_id := Error
					else
						-- Extract the session key.
						number := s.substring (
							i + Message_field_separator.count, j - 1)
						if not number.is_integer then
							report_error ("Session key is not a valid " +
								"integer: " + number, Void, Void)
							request_id := Error
						else
							session_key := number.to_integer
							if not session_valid then
								report_error ("Non-existent session key (" +
									session_key.out + "(for request ID: " +
									request_id.out + ".%N(May be a stale " +
									"session", Void, " (Session may be stale.)")
								request_id := Error
							else
								set_message_body (
									s, j + Message_field_separator.count)
							end
						end
					end
				end
			end
			check
				message_body_set: message_body /= Void
			end
		end

	is_logout_request (id: like request_id): BOOLEAN is
		do
			Result := id = Logout_request
		end

	is_login_request (id: like request_id): BOOLEAN is
		do
			Result := id = Login_request
		end

feature {NONE} -- Implementation

	set_message_body (s: STRING; index: INTEGER) is
			-- Set `message_body' from string extracted from `s' @ `index'.
		do
			message_body := s.substring (index, s.count)
		end

	report_error (log_msg, client_msg, client_suffix: STRING) is
			-- Log `log_msg' as an error and report `client_msg' (or, if
			-- it is Void, `default_client_error_msg'), and `client_suffix',
			-- if it's not Void, to the client.
		require
			log_msg_exists: log_msg /= Void
		do
			log_error (log_msg)
			if client_msg /= Void then
				message_body := client_msg
			else
				message_body := clone (default_client_error_msg)
			end
			if client_suffix /= Void then
				message_body.append (client_suffix)
			end
		ensure
			non_void_msg_body_set_to_client_msg:
				client_msg /= Void implies message_body = client_msg
			void_msg_body_set_to_default_msg:
				client_msg = Void implies message_body.substring (1,
				default_client_error_msg.count).is_equal (
				default_client_error_msg)
			message_body_exists: message_body /= Void
		end

feature {NONE} -- Attributes

	message_body: STRING
			-- body of last client request

	session_key: INTEGER
			-- Key for the current session, extracted by `process_request'

feature {NONE} -- Constants

	Maximum_client_message_size: INTEGER is 100000

	Default_client_error_msg: STRING is
		once
			Result := "Invalid request"
		end

end
