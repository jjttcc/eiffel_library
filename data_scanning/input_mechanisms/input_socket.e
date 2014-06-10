note
	description: "Network stream sockets used only for input"
	author: "Jim Cochrane"
	note1: "The expected protocol from the server socket from which %
		%INPUT_SOCKETs get their input is that the end of the data stream %
		%is indicated by an empty line - that is, two newlines in a row. %
		%To use a different protocol, a descendant class that implements %
		%the protocol needs to be created."
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

--!!!Is record_separator needed any more?
class INPUT_SOCKET inherit

	NETWORK_STREAM_SOCKET
		export
			{NONE} all
			{INPUT_SOCKET_CLIENT} is_linger_on, linger_time, set_delay,
				set_linger_off, set_linger_on, set_nodelay, set_timeout,
				timeout, set_blocking, set_non_blocking, is_blocking, socket_ok
		undefine
			read_integer, read_real, read_double, read_line, readline
		redefine
			make_client_by_port
		end

	INPUT_MEDIUM
		rename
			handle as descriptor, handle_available as descriptor_available
		redefine
			split_current_record_on_start
		end

creation

	make_client_by_port

feature -- Initialization

	make_client_by_port (port_num: INTEGER; host: STRING)
			-- Create the socket with `port_num', `host', and `connection'.
		do
			Precursor (port_num, host)
			current_record := Void
			field_separator := " "
		end

feature -- Status report

	data_available: BOOLEAN
		do
			Result := is_open_read and readable
		end

feature -- Input

	read_line, readline
local
sdb: SOCKET_DEBUGGER
		do
create sdb.make_with_socket (Current)
--!!!!:
--print ("socket report before reading line:%N" + sdb.report (Void) + "%N")
			create last_string.make (512);
			read_character;
			from
			until
				last_character = '%N' or last_character = '%U'
			loop
				last_string.extend (last_character);
				read_character
			end
--!!!!:
--print ("socket report after reading line:%N" + sdb.report (Void) + "%N")
		end;

feature {NONE} -- Hook routine implementations

	split_current_record_on_start: BOOLEAN
		do
			Result := current_record = Void
		end

end
