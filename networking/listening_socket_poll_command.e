note

	description: "POLL_COMMANDs whose `active_medium' is a %
		%NETWORK_STREAM_SOCKET - server socket - and that delegates accepting %
		%connections from that socket to a SOCKET_ACCEPTOR object."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class LISTENING_SOCKET_POLL_COMMAND

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

	make (s: like socket_processor)
		require
			s_not_void: s /= Void
			srvr_socket_not_void: s.server_socket /= Void
		do
			socket_processor := s
			pc_make (socket_processor.server_socket)
			socket.listen (5)
		ensure
			set: socket = s.server_socket
		end

feature -- Access

	socket: NETWORK_STREAM_SOCKET
			-- The socket used for establishing a connection

	socket_processor: SERVER_SOCKET_PROCESSOR

feature -- Basic operations

	execute (arg: ANY)
		do
			socket_processor.process_socket
		end

end
