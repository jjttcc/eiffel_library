indexing
	description: "Network stream sockets used only for input"
	author: "Jim Cochrane"
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
			read_integer, read_real, read_double
		end

	INPUT_MEDIUM
		rename
			handle as descriptor, handle_available as descriptor_available
		end

creation {SOCKET_TRADABLE_LIST}

	make_client_by_port

feature -- Initialization

feature -- Status report

	data_available: BOOLEAN is
		do
			Result := is_open_read and readable
		end

feature -- Cursor movement

invariant

	exists_and_is_open_read: exists and not is_closed implies is_open_read

end
