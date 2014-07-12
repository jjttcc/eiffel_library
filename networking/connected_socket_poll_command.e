note

    description: "POLL_COMMANDs whose `active_medium' is a connected socket"
    author: "Jim Cochrane"
    date: "$Date$";
    revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    --settings: vim: expandtab:

class CONNECTED_SOCKET_POLL_COMMAND

inherit

    POLL_COMMAND
        rename
            active_medium as socket, make as pc_make
        redefine
            socket
        end

create

    make

feature {NONE} -- Initialization

    make (s: SOCKET; poll: MEDIUM_POLLER)
        do
            pc_make(s)
            poller := poll
            poller.put_read_command(Current)
        ensure then
            poller = poll
        end

feature -- Access

    socket: SOCKET

--!!!!!socket-enhancement: check if this is needed:
    poller: MEDIUM_POLLER

feature -- Basic operations

    execute (arg: ANY)
        do
--!!!!!!!!!!!!!!!!            poller.remove_read_command(Current)
        end

    cleanup
            -- Cleanup before removal/destruction.
        do
            poller.remove_read_command(Current)
            socket.close
        end
end
