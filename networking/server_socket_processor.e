note

	description: "Objects that 'accept' a server socket connection and %
		%perform input/output operations on the resulting socket object"
	author: "Jim Cochrane"
	date: "$Date: 2006-04-04 21:28:13 -0600 (Tue, 04 Apr 2006) $";
	revision: "$Revision: 586 $"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class SERVER_SOCKET_PROCESSOR inherit

	SOCKET_PROCESSOR
		redefine
			cleanup, post_process, initialize_target_socket
		end

feature -- Access

	server_socket: NETWORK_STREAM_SOCKET

feature {NONE} -- Implementation

	post_process
			-- Perform any processing needed after calling `do_execute'.
		do
			target_socket.close
		end

	initialize_target_socket
			-- Set target_socket to the "accepted" socket.
		do
			server_socket.accept
			target_socket := server_socket.accepted
		ensure then
			accepted_socket_accepted: target_socket = server_socket.accepted
		end

	cleanup
		do
			Precursor
			if
				server_socket /= Void and then not server_socket.is_closed
			then
				server_socket.close
			end
		end

end
