note

	description: "Objects that 'accept' a server socket connection and %
		%perform input/output operations on the resulting socket object"
	author: "Jim Cochrane"
	date: "$Date: 2006-04-04 21:28:13 -0600 (Tue, 04 Apr 2006) $";
	revision: "$Revision: 586 $"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class SOCKET_ACCEPTOR inherit

	CLEANUP_SERVICES
		export
			{NONE} all
			{ANY} deep_twin, is_deep_equal, standard_is_equal
		end

	TERMINABLE
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	initialize_components (s: like server_socket)
		do
			server_socket := s
			register_for_termination (Current)
		ensure
			set: server_socket = s
		end

feature -- Access

	accepted_socket: SOCKET
			-- The socket that will be used for input and output

	server_socket: NETWORK_STREAM_SOCKET

	is_non_persistent_connection: BOOLEAN
			-- Is the current client connection a non-persistent connection?

	interface: CONNECTION_INTERFACE
			-- The interface used for the conversation with the client

	persistent_connection_interface: PERSISTENT_CONNECTION_INTERFACE
			-- The interface used for persistent connections

	non_persistent_connection_interface: NON_PERSISTENT_CONNECTION_INTERFACE
			-- The interface used for non-persistent connections

feature -- Basic operations

	process_socket
		do
			execute
		end

feature {NONE} -- Implementation

	execute
		do
			initialize_for_execution
			do_execute
			post_process
		end

	initialize_for_execution
			-- Perform initialization needed before calling `do_execute'.
		do
			server_socket.accept
			accepted_socket := server_socket.accepted
			accepted_socket.read_character
			if
				accepted_socket.last_character.is_equal (
					Persistent_connection_flag)
			then
				is_non_persistent_connection := False
			else
				is_non_persistent_connection := True
			end
		ensure
			accepted_socket_accepted: accepted_socket = server_socket.accepted
		end

	do_execute
			-- Perform the main processing.
		do
			if is_non_persistent_connection then
				prepare_for_non_persistent_connection
				non_persistent_connection_interface.set_io_medium (
					accepted_socket)
				interface := non_persistent_connection_interface
			else
				prepare_for_persistent_connection
				persistent_connection_interface.set_input_device (
					accepted_socket)
				persistent_connection_interface.set_output_device (
					accepted_socket)
				interface := persistent_connection_interface
			end
			-- !!!Out of date - remove: When threads are added, this call
			-- may change to "interface.launch" to run in a separate thread.
			interface.execute
		end

--!!!!!!socket-enhancement: When is cleanup called??!!!!
	cleanup
		do
print ("!!!!!!!!!SOCKET_ACCEPTOR.cleanup called!!!!!!!%N")
			if
				accepted_socket /= Void and then not accepted_socket.is_closed
			then
				if not is_non_persistent_connection then
					terminate_persistent_connection
				end
				accepted_socket.close
			end
		end

	terminate_persistent_connection
			-- Terminate the persistent connection.
		require
			persistent_connection: not is_non_persistent_connection
		do
			accepted_socket.put_character (connection_termination_character)
		end

feature {NONE} -- Implementation - Hook routines

	prepare_for_non_persistent_connection
			-- Perform any needed specialized preparation for the
			-- non-persistent connection.
		do
			-- Null action - redefine if needed.
		end

	prepare_for_persistent_connection
			-- Perform any needed specialized preparation for the
			-- persistent connection.
		do
			-- Null action - redefine if needed.
		end

	post_process
			-- Perform any processing needed after calling `do_execute'.
		do
			accepted_socket.close
		end

	Persistent_connection_flag: CHARACTER
			-- Character that "flags" the connection as being persistent
		deferred
		end

	connection_termination_character: CHARACTER
			-- Character that tells the client that the connection has
			-- been terminated.
		deferred
		end

end
