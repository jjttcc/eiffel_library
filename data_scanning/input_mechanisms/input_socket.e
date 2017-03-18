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
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

--!!!Is record_separator needed any more?
class INPUT_SOCKET inherit

    NETWORK_STREAM_SOCKET
        export
          {NONE} all
          {INPUT_SOCKET_CLIENT} is_linger_on, linger_time, set_delay,
              set_linger_off, set_linger_on, set_nodelay, set_timeout,
              timeout, socket_ok,
              error, put_string, connect, is_open_read, is_open_write,
              peer_address, extendible
          {INPUT_SOCKET_CLIENT, INPUT_SOCKET} is_blocking, set_non_blocking,
              set_blocking, set_peer_address, is_valid_peer_address
          {INPUT_SOCKET} is_created, make_from_descriptor_and_address
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

create

    make_client_by_port, make_empty

create {NETWORK_STREAM_SOCKET}

    make_from_descriptor_and_address

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
