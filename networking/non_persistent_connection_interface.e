note
	description: "Interface for a %"non-persistent%" connection"
	author: "Jim Cochrane"
	date: "$Date$";
	note1: "It is expected that, before `execute' is called, the first %
		%character of the input of io_medium has been read."
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

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

	sessions: HASH_TABLE [SESSION, INTEGER]
			-- Registered GUI Client sessions
		deferred
		end

feature -- Element change

	set_io_medium (arg: like io_medium)
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

	post_process_io_medium
			-- Perform any postprocessing needed after setting `io_medium'.
		deferred
		end

	end_of_message (c: CHARACTER): BOOLEAN
			-- Does `c' designate the end of a message?
		deferred
		end

	message_field_separator: STRING
			-- Field separator used to parse `message_body'
		deferred
		end

	message_record_separator: STRING
			-- Record separator used to parse `message_body'
		deferred
		end

	logout_request: INTEGER
			-- Code for a logout request
		deferred
		end

	login_request: INTEGER
			-- Code for a login request
		deferred
		end

	error: INTEGER
			-- Code indicating an error occurred while processing the
			-- last client request
		deferred
		end

	log_error (msg: STRING)
			-- Log `msg' as an error.
		deferred
		end

feature {NONE} -- Hook routines implementations

	setup_command (cmd: like command_type_anchor)
		do
			cmd.set_output_medium (io_medium)
		end

	request_error: BOOLEAN
		do
			Result := request_id.is_equal (Error)
		end

	session: SESSION
		do
			if sessions.has (session_key) then
				Result := sessions @ session_key
			end
		end

	cleanup_session
		do
			sessions.remove (session_key)
		end

	process_request
			-- Input the next client request, blocking if necessary, and split
			-- the received message into `request_id', `session_key',
			-- and `message_body'.
		local
			s, number: STRING
			i, loop_count, candidate_req_id: INTEGER
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
				else
					candidate_req_id := number.to_integer
					if
						not request_handlers.has (candidate_req_id) and
						candidate_req_id /= Logout_request
					then
						report_error ("Invalid request ID: " + number,
							Void, Void)
						request_id := Error
					else
						set_request_id_session_key (s, candidate_req_id, i)
					end
				end
			end
			check
				message_body_set: message_body /= Void
			end
		end

	set_request_id_session_key (s: STRING; n, i: INTEGER)
			-- Set `request_id' and `session_key'.
		local
			j: INTEGER
			number: STRING
		do
			request_id := n
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

	is_logout_request (id: like request_id): BOOLEAN
		do
			Result := id.is_equal (Logout_request)
		end

	is_login_request (id: like request_id): BOOLEAN
		do
			Result := id.is_equal (Login_request)
		end

feature {NONE} -- Implementation

	command_type_anchor: IO_BASED_CLIENT_REQUEST_COMMAND
		do
		end

	set_message_body (s: STRING; index: INTEGER)
			-- Set `message_body' from string extracted from `s' @ `index'.
		do
			message_body := s.substring (index, s.count)
		end

	report_error (log_msg, client_msg, client_suffix: STRING)
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
				message_body := default_client_error_msg.twin
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

	maximum_client_message_size: INTEGER = 100000

	default_client_error_msg: STRING
		once
			Result := "Invalid request"
		end

end
