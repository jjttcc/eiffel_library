indexing

	description:
		"POLL_COMMANDs whose `active_medium' is a NETWORK_STREAM_SOCKET"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
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

feature

	active_medium: NETWORK_STREAM_SOCKET
			-- The socket used for establishing a connection and creating
			-- io_socket

	io_socket: SOCKET
			-- The socket that will be used for input and output

	execute (arg: ANY) is
		do
			initialize_for_execution
			do_execute (arg)
			post_process
		end

	initialize_for_execution is
			-- Perform initialization needed before calling `do_execute'.
		do
			active_medium.accept
			io_socket := active_medium.accepted
		ensure
			io_socket_accepted: io_socket = active_medium.accepted
		end

feature {NONE} -- Implementation - Hook routines

	do_execute (arg: ANY) is
			-- Perform the main processing.
		deferred
		end

	post_process is
			-- Perform any processing needed after calling `do_execute'.
		do
			io_socket.close
		ensure
			io_socket_is_closed: io_socket.is_closed
		end

end
