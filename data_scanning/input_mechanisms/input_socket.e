indexing
	description: "Network stream sockets used only for input"
	author: "Jim Cochrane"
	note: "The expected protocol from the server socket from which %
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
		undefine
			read_integer, read_real, read_double, read_line, readline
		end

	INPUT_MEDIUM
		rename
			handle as descriptor, handle_available as descriptor_available
		redefine
			split_current_record_on_start
		end

creation

	make_with_connection_tool

feature -- Initialization

	make_with_connection_tool (port_num: INTEGER; host: STRING;
		connection: like communication_tool) is
			-- Create the socket with `port_num', `host', and `connection'.
		do
			make_client_by_port (port_num, host)
			communication_tool := connection
			current_record := Void
			field_separator := " "
		end

feature -- Status report

	data_available: BOOLEAN is
		do
			Result := is_open_read and readable
		end

feature -- Input

	read_line, readline is
		do
			create last_string.make (512);
			read_character;
			from
			until
				last_character = '%N' or last_character = '%U'
			loop
				last_string.extend (last_character);
				read_character
			end
		end;

feature {NONE} -- Hook routine implementations

	split_current_record_on_start: BOOLEAN is
		do
			Result := current_record = Void
		end

feature {NONE} -- Implementation

	communication_tool: INPUT_DATA_CONNECTION

end
