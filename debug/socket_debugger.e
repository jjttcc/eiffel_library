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
			print ("<<<BEGIN SOCKET REPORT>>>" + "%N")
			print ("address_in_use: " +
				 target_socket.address_in_use.out + "%N")
			print ("address_not_readable: " +
				 target_socket.address_not_readable.out + "%N")
			print ("already_bound: " +
				 target_socket.already_bound.out + "%N")
			print ("bad_socket_handle: " +
				 target_socket.bad_socket_handle.out + "%N")
			print ("connect_in_progress: " +
				 target_socket.connect_in_progress.out + "%N")
			print ("connection_refused: " +
				 target_socket.connection_refused.out + "%N")
			print ("dtable_full: " +
				 target_socket.dtable_full.out + "%N")
			print ("error: " +
				 target_socket.error.out + "%N")
			print ("error_number: " +
				 target_socket.error_number.out + "%N")
			print ("expired_socket: " +
				 target_socket.expired_socket.out + "%N")
			print ("invalid_address: " +
				 target_socket.invalid_address.out + "%N")
			print ("invalid_socket_handle: " +
				 target_socket.invalid_socket_handle.out + "%N")
			print ("is_plain_text: " +
				 target_socket.is_plain_text.out + "%N")
			print ("last_character: " +
				 target_socket.last_character.out + "%N")
			print ("last_double: " +
				 target_socket.last_double.out + "%N")
			print ("last_integer: " +
				 target_socket.last_integer.out + "%N")
			print ("last_real: " +
				 target_socket.last_real.out + "%N")
			print ("last_string: " +
				 target_socket.last_string.out + "%N")
			print ("network: " +
				 target_socket.network.out + "%N")
			print ("no_buffers: " +
				 target_socket.no_buffers.out + "%N")
			print ("no_permission: " +
				 target_socket.no_permission.out + "%N")
			print ("not_connected: " +
				 target_socket.not_connected.out + "%N")
			print ("protected_address: " +
				 target_socket.protected_address.out + "%N")
			print ("protocol_not_supported: " +
				 target_socket.protocol_not_supported.out + "%N")
			print ("socket_family_not_supported: " +
				 target_socket.socket_family_not_supported.out + "%N")
			print ("socket_in_use: " +
				 target_socket.socket_in_use.out + "%N")
			print ("socket_ok: " +
				 target_socket.socket_ok.out + "%N")
			print ("socket_would_block: " +
				 target_socket.socket_would_block.out + "%N")
			print ("support_storable: " +
				 target_socket.support_storable.out + "%N")
			print ("zero_option: " +
				 target_socket.zero_option.out + "%N")
			print ("name: " +
				 target_socket.name.out + "%N")
			print ("descriptor: " +
				 target_socket.descriptor.out + "%N")
			print ("descriptor_available: " +
				 target_socket.descriptor_available.out + "%N")
			print ("family: " +
				 target_socket.family.out + "%N")
			print ("is_closed: " +
				 target_socket.is_closed.out + "%N")
			print ("peer_address: " +
				 target_socket.peer_address.out + "%N")
			print ("protocol: " +
				 target_socket.protocol.out + "%N")
			print ("type: " +
				 target_socket.type.out + "%N")
			print ("c_msgdontroute: " +
				 target_socket.c_msgdontroute.out + "%N")
			print ("c_oobmsg: " +
				 target_socket.c_oobmsg.out + "%N")
			print ("c_peekmsg: " +
				 target_socket.c_peekmsg.out + "%N")
			print ("exists: " +
				 target_socket.exists.out + "%N")
			print ("extendible: " +
				 target_socket.extendible.out + "%N")
			print ("is_executable: " +
				 target_socket.is_executable.out + "%N")
			print ("is_open_read: " +
				 target_socket.is_open_read.out + "%N")
			print ("is_open_write: " +
				 target_socket.is_open_write.out + "%N")
			print ("is_readable: " +
				 target_socket.is_readable.out + "%N")
			print ("is_writable: " +
				 target_socket.is_writable.out + "%N")
			print ("readable: " +
				 target_socket.readable.out + "%N")
			print ("debug_enabled: " +
				 target_socket.debug_enabled.out + "%N")
			print ("group_id: " +
				 target_socket.group_id.out + "%N")
			print ("is_blocking: " +
				 target_socket.is_blocking.out + "%N")
			print ("is_group_id: " +
				 target_socket.is_group_id.out + "%N")
			print ("is_process_id: " +
				 target_socket.is_process_id.out + "%N")
			print ("is_socket_stream: " +
				 target_socket.is_socket_stream.out + "%N")
			print ("process_id: " +
				 target_socket.process_id.out + "%N")
			print ("receive_buf_size: " +
				 target_socket.receive_buf_size.out + "%N")
			print ("route_enabled: " +
				 target_socket.route_enabled.out + "%N")
			print ("send_buf_size: " +
				 target_socket.send_buf_size.out + "%N")
			print ("<<<END SOCKET REPORT>>>" + "%N")
		end

end -- class TIMER
