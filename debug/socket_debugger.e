indexing
	description: "Debugging facilities for SOCKETs";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	SOCKET_DEBUGGER

creation

	make_with_socket

feature

	make_with_socket (s: SOCKET) is
			-- Initialize and start the timer.
		require
			s_exists: s /= Void
		do
			target_socket := s
		ensure
			set: target_socket = s
		end

feature -- Access

	target_socket: SOCKET
			-- The target socket

feature -- Status report

	report (s: SOCKET): STRING is
			-- Report on the state of: `s' if exists; otherwise,
			-- `target_socket'.
		require
			s_exists_or_target_exists: s /= Void or target_socket /= Void
		local
			debug_socket: SOCKET
		do
			debug_socket := s
			if debug_socket = Void then
				debug_socket := target_socket
			end
			Result := "<<<BEGIN SOCKET REPORT>>>" + "%N" +
				"address_in_use: " +
				 debug_socket.address_in_use.out + "%N" +
				"address_not_readable: " +
				 debug_socket.address_not_readable.out + "%N" +
				"already_bound: " +
				 debug_socket.already_bound.out + "%N" +
				"bad_socket_handle: " +
				 debug_socket.bad_socket_handle.out + "%N" +
				"connect_in_progress: " +
				 debug_socket.connect_in_progress.out + "%N" +
				"connection_refused: " +
				 debug_socket.connection_refused.out + "%N" +
				"dtable_full: " +
				 debug_socket.dtable_full.out + "%N" +
				"error: " +
				 debug_socket.error.out + "%N" +
				"error_number: " +
				 debug_socket.error_number.out + "%N" +
				"expired_socket: " +
				 debug_socket.expired_socket.out + "%N" +
				"invalid_address: " +
				 debug_socket.invalid_address.out + "%N" +
				"invalid_socket_handle: " +
				 debug_socket.invalid_socket_handle.out + "%N" +
				"is_plain_text: " +
				 debug_socket.is_plain_text.out + "%N" +
				"network: " +
				 debug_socket.network.out + "%N" +
				"no_buffers: " +
				 debug_socket.no_buffers.out + "%N" +
				"no_permission: " +
				 debug_socket.no_permission.out + "%N" +
				"not_connected: " +
				 debug_socket.not_connected.out + "%N" +
				"protected_address: " +
				 debug_socket.protected_address.out + "%N" +
				"protocol_not_supported: " +
				 debug_socket.protocol_not_supported.out + "%N" +
				"socket_family_not_supported: " +
				 debug_socket.socket_family_not_supported.out + "%N" +
				"socket_in_use: " +
				 debug_socket.socket_in_use.out + "%N" +
				"socket_ok: " +
				 debug_socket.socket_ok.out + "%N" +
				"socket_would_block: " +
				 debug_socket.socket_would_block.out + "%N" +
				"support_storable: " +
				 debug_socket.support_storable.out + "%N" +
				"zero_option: " +
				 debug_socket.zero_option.out + "%N" +
				"name: " +
				 debug_socket.name.out + "%N" +
				"descriptor: " +
				 debug_socket.descriptor.out + "%N" +
				"descriptor_available: " +
				 debug_socket.descriptor_available.out + "%N" +
				"family: " +
				 debug_socket.family.out + "%N" +
				"is_closed: " +
				 debug_socket.is_closed.out + "%N" +
				"peer_address: " +
				 debug_socket.peer_address.out + "%N" +
				"protocol: " +
				 debug_socket.protocol.out + "%N" +
				"type: " +
				 debug_socket.type.out + "%N" +
				"c_msgdontroute: " +
				 debug_socket.c_msgdontroute.out + "%N" +
				"c_oobmsg: " +
				 debug_socket.c_oobmsg.out + "%N" +
				"c_peekmsg: " +
				 debug_socket.c_peekmsg.out + "%N" +
				"exists: " +
				 debug_socket.exists.out + "%N" +
				"extendible: " +
				 debug_socket.extendible.out + "%N" +
				"is_executable: " +
				 debug_socket.is_executable.out + "%N" +
				"is_open_read: " +
				 debug_socket.is_open_read.out + "%N" +
				"is_open_write: " +
				 debug_socket.is_open_write.out + "%N" +
				"is_readable: " +
				 debug_socket.is_readable.out + "%N" +
				"is_writable: " +
				 debug_socket.is_writable.out + "%N" +
				"readable: " +
				 debug_socket.readable.out + "%N" +
				"debug_enabled: " +
				 debug_socket.debug_enabled.out + "%N" +
				"group_id: " +
				 debug_socket.group_id.out + "%N" +
				"is_blocking: " +
				 debug_socket.is_blocking.out + "%N" +
				"is_group_id: " +
				 debug_socket.is_group_id.out + "%N" +
				"is_process_id: " +
				 debug_socket.is_process_id.out + "%N" +
				"is_socket_stream: " +
				 debug_socket.is_socket_stream.out + "%N" +
				"process_id: " +
				 debug_socket.process_id.out + "%N" +
				"receive_buf_size: " +
				 debug_socket.receive_buf_size.out + "%N" +
				"route_enabled: " +
				 debug_socket.route_enabled.out + "%N" +
				"send_buf_size: " +
				 debug_socket.send_buf_size.out + "%N" +
				"<<<END SOCKET REPORT>>>" + "%N"
		end

end -- class TIMER
