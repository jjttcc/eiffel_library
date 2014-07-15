note

    description: "Objects that perform input/output operations on a target%
        %socket object"
    author: "Jim Cochrane"
    date: "$Date: 2006-04-04 21:28:13 -0600 (Tue, 04 Apr 2006) $";
    revision: "$Revision: 586 $"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    --settings: vim: expandtab:

deferred class SOCKET_PROCESSOR

inherit

    TERMINABLE

    CLEANUP_SERVICES

feature {NONE} -- Initialization

    initialize
        do
            if termination_required then
                register_for_termination(Current)
            end
        end

feature -- Access

    target_socket: SOCKET
            -- The socket that will be used for input and output

    is_non_persistent_connection: BOOLEAN
            -- Is the current client connection a non-persistent connection?

    interface: CONNECTION_INTERFACE
            -- The interface used for the conversation with the client

    persistent_connection_interface: PERSISTENT_CONNECTION_INTERFACE
            -- The interface used for persistent connections

    non_persistent_connection_interface: NON_PERSISTENT_CONNECTION_INTERFACE
            -- The interface used for non-persistent connections

feature -- Status report

    error_occurred: BOOLEAN
            -- Did an error occur during the last socket operation?

feature -- Basic operations

    process_socket
        do
            execute
        end

feature {NONE} -- Implementation

    execute
        do
            initialize_for_execution
            if error_occurred then
                handle_error
--!!!!!![socket-enh]                error_occurred := False
            else
                do_execute
                post_process
            end
        end

    initialize_for_execution
            -- Perform initialization needed before calling `do_execute'.
        do
            initialize_target_socket
            if target_socket.socket_ok then
                -- NOTE: Bug fix needed: A misbehaving client could cause this
                -- 'read_character' call to block indefinitely.
                target_socket.read_character
                if
                    target_socket.last_character.is_equal(
                    Persistent_connection_flag)
                    then
                    is_non_persistent_connection := False
                else
                    is_non_persistent_connection := True
                end
            else
                error_occurred := True
            end
            initialize_interfaces
        end

    do_execute
            -- Perform the main processing.
        do
            if is_non_persistent_connection then
                prepare_for_non_persistent_connection
                non_persistent_connection_interface.set_io_medium(target_socket)
                interface := non_persistent_connection_interface
            else
                prepare_for_persistent_connection
                persistent_connection_interface.set_input_device(target_socket)
                persistent_connection_interface.set_output_device(target_socket)
                interface := persistent_connection_interface
            end
            interface.execute
        end

--!!!!!!socket-enhancement: When is cleanup called??!!!!
    cleanup
        do
print("!!!!!!!!!SOCKET_PROCESSOR.cleanup called for " + Current.out + "%N")
            if
                target_socket /= Void and then not target_socket.is_closed
            then
                if not is_non_persistent_connection then
                    terminate_persistent_connection
                end
                target_socket.close
            end
        end

    terminate_persistent_connection
            -- Terminate the persistent connection.
        require
            persistent_connection: not is_non_persistent_connection
        do
            target_socket.put_character(connection_termination_character)
        end

    handle_error
            -- Process the last error that occurred.
        local
            msg: STRING
        do
            if target_socket /= Void then
                msg := "Socket operation error"
                if target_socket.error /= Void then
                    msg := msg + ": " + target_socket.error
                end
                log_socket_error(msg)
            end
        end

feature {NONE} -- Implementation - Hook routines

    termination_required: BOOLEAN
            -- Is termination/cleanup needed for SOCKET_PROCESSOR instances?
        do
            Result := True
        end

    initialize_target_socket
            -- Make sure the target socket exists and is open.
        do
        ensure
            target_socket /= Void and then not target_socket.is_closed
        end

    initialize_interfaces
            -- Initialize the interface attributes
        deferred
        ensure
            non_persistent: is_non_persistent_connection implies
                non_persistent_connection_interface /= Void
            persistent: not is_non_persistent_connection implies
                persistent_connection_interface /= Void
        end

    prepare_for_non_persistent_connection
            -- Perform any needed specialized preparation for the
            -- non-persistent connection.
        do
            -- Null action - redefine if needed.
        end

    prepare_for_persistent_connection
            -- Perform any needed specialized preparation for the
            -- persistent connection.
        do
            -- Null action - redefine if needed.
        end

    post_process
            -- Perform any processing needed after calling `do_execute'.
        do
            do_nothing
        end

    Persistent_connection_flag: CHARACTER
            -- Character that "flags" the connection as being persistent
        deferred
        end

    connection_termination_character: CHARACTER
            -- Character that tells the client that the connection has
            -- been terminated.
        deferred
        end

    log_socket_error(msg: STRING)
            -- Send 'msg' to an appropriate destination/device.
            -- (default: send to stderr - redefine if needed)
        do
            if msg[msg.count] ~ "%N" then
                io.error.print(msg)
            else
                -- No newline at end, so add it.
                io.error.print(msg + "%N")
            end
        end

end
