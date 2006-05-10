indexing

	description: "POLL_COMMANDs whose `active_medium' is a %
		%NETWORK_STREAM_SOCKET - server socket - and that delegates accepting %
		%connections from that socket to a SOCKET_ACCEPTOR object."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class SOCKET_BASED_POLL_COMMAND

inherit

	POLL_COMMAND
		rename
			make as pc_make, active_medium as socket
		redefine
			socket
		end

create

	make

feature {NONE} -- Initialization

	make (s: like acceptor) is
		do
			acceptor := s
			pc_make (acceptor.server_socket)
			socket.listen (5)
		ensure
			set: socket = s.server_socket
		end

feature -- Access

	socket: NETWORK_STREAM_SOCKET
			-- The socket used for establishing a connection

	acceptor: SOCKET_ACCEPTOR

feature -- Basic operations

	execute (arg: ANY) is
		do
			acceptor.process_socket
		end

end
