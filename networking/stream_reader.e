indexing

	description: "POLL_COMMANDs whose `active_medium' is a %
		%NETWORK_STREAM_SOCKET and that activate a persistent-connection %
		%interface or a non-persistent-connection interface, depending on %
		%the value of the first character read from `active_medium'"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class STREAM_READER

inherit

	POLL_COMMAND
		rename
			make as pc_make
		redefine
			active_medium
		end

	CLEANUP_SERVICES
		export
			{NONE} all
		end

	TERMINABLE
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	initialize_components (s: like active_medium) is
		do
			pc_make (s)
			active_medium.listen (5)
			register_for_termination (Current)
		ensure
			set: active_medium = s
		end

feature -- Access

	active_medium: NETWORK_STREAM_SOCKET
			-- The socket used for establishing a connection and creating
			-- io_socket

	io_socket: SOCKET
			-- The socket that will be used for input and output

	is_non_persistent_connection: BOOLEAN
			-- Is the current client connection a non-persistent connection?

	interface: CONNECTION_INTERFACE
			-- The interface used for the conversation with the client

	persistent_connection_interface: PERSISTENT_CONNECTION_INTERFACE
			-- The interface used for persistent connections

	non_persistent_connection_interface: NON_PERSISTENT_CONNECTION_INTERFACE
			-- The interface used for non-persistent connections

feature -- Basic operations

	execute (arg: ANY) is
		do
			initialize_for_execution
			do_execute (arg)
			post_process
		end

feature {NONE} -- Implementation

	initialize_for_execution is
			-- Perform initialization needed before calling `do_execute'.
		do
			active_medium.accept
			io_socket := active_medium.accepted
			io_socket.read_character
			if
				io_socket.last_character.is_equal (Persistent_connection_flag)
			then
				is_non_persistent_connection := False
			else
				is_non_persistent_connection := True
			end
		ensure
			io_socket_accepted: io_socket = active_medium.accepted
		end

	do_execute (arg: ANY) is
			-- Perform the main processing.
		do
			if is_non_persistent_connection then
				prepare_for_non_persistent_connection
				non_persistent_connection_interface.set_io_medium (io_socket)
				interface := non_persistent_connection_interface
			else
				prepare_for_persistent_connection
				persistent_connection_interface.set_input_device (io_socket)
				persistent_connection_interface.set_output_device (io_socket)
				interface := persistent_connection_interface
			end
			-- When threads are added, this call will probably change to
			-- "interface.launch" to run in a separate thread.
			interface.execute
		end

	cleanup is
		do
			if io_socket /= Void and then not io_socket.is_closed then
				if not is_non_persistent_connection then
					terminate_persistent_connection
				end
				io_socket.close
			end
		end

	terminate_persistent_connection is
			-- Terminate the persistent connection.
		require
			persistent_connection: not is_non_persistent_connection
		do
			io_socket.put_character (connection_termination_character)
		end

feature {NONE} -- Implementation - Hook routines

	prepare_for_non_persistent_connection is
			-- Perform any needed specialized preparation for the
			-- non-persistent connection.
		do
			-- Null action - redefine if needed.
		end

	prepare_for_persistent_connection is
			-- Perform any needed specialized preparation for the
			-- persistent connection.
		do
			-- Null action - redefine if needed.
		end

	post_process is
			-- Perform any processing needed after calling `do_execute'.
		do
			io_socket.close
		ensure
			io_socket_is_closed: io_socket.is_closed
		end

	Persistent_connection_flag: CHARACTER is
			-- Character that "flags" the connection as being persistent
		deferred
		end

	connection_termination_character: CHARACTER is
			-- Character that tells the client that the connection has
			-- been terminated.
		deferred
		end

end
