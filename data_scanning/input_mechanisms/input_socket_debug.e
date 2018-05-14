note
    description: "Debugging INPUT_SOCKET - reads all records up front"
    author: "Jim Cochrane"
    date: "$Date$";
    revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    -- vim: expandtab

class INPUT_SOCKET_DEBUG inherit

    INPUT_SOCKET
        redefine
            split_current_record_on_start, split_current_record, start,
            advance_to_next_record, discard_current_record, record_index,
            field_count, at_end_of_input, make_client_by_port
        end

create

    make_client_by_port, make_empty


create {NETWORK_STREAM_SOCKET}

    make_from_descriptor_and_address

feature

    make_client_by_port (port_num: INTEGER; host: STRING)
        do
            Precursor (port_num, host)
            record_separator := "%N"
            field_separator := "%T"
        end

feature -- Access

    last_input_string: STRING
            -- The buffered input resulting from the last call to
            -- `pre_process_input' - NOTE: For performance reasons, this
            -- object is used internally and a clone is not created in
            -- the call to `pre_process_input'.  Therefore, care must be
            -- taken to ensure that no unwanted side effects occur as a
            -- result of sharing this object.

    record_index: INTEGER
        do
            if all_records /= Void then
                Result := all_records.index
            end
        end

    field_count: INTEGER
        do
            if all_records /= Void and not all_records.is_empty then
                if all_records.off then
                    all_records.start
                end
                if current_record = Void then
                    split_current_record
                end
                Result := current_record.count
            end
        ensure then
            none_if_no_recs: all_records = Void or all_records.is_empty implies
                Result = 0
        end

feature -- Status report

    at_end_of_input: BOOLEAN
        do
            Result := last_string = Void or else last_string.is_empty
        end

feature -- Cursor movement

    advance_to_next_record, discard_current_record
        do
            last_error_fatal := False
            error_occurred := False
            all_records.forth
            after_last_record := all_records.exhausted
            if not after_last_record then
                split_current_record
                current_record.start
            end
        end

    start
        do
--!!!! These 3 lines are probably wrong.  `pre_process_input' is called
--explicitly by INPUT_SOCKET_CLIENT and it should not be called again:
            if all_records = Void and readable then
                pre_process_input
            end
            all_records.start
            after_last_record := all_records.exhausted
            if not after_last_record then
                split_current_record
                current_record.start
            end
        end

feature {INPUT_SOCKET_CLIENT} -- Input

    pre_process_input
            -- Read all pending input from the server, pre-process and
            -- buffer it (for use in the conventional 'read_...' calls), and
            -- place the resulting buffered input into `last_input_string'.
        require
            socket_ok: socket_ok
        do
            last_input_string := pending_input
            if socket_ok then
                create {LINKED_LIST [STRING]} all_records.make
                if last_input_string.is_empty then
                else
                    all_records.append(
                        last_input_string.split (record_separator @ 1))
                end
            else
                create {LINKED_LIST [STRING]} all_records.make
                last_input_string := ""
                error_string := error
                error_occurred := True
            end
        ensure
            last_input_string_exists: last_input_string /= Void
            all_records_exist: all_records /= Void
            all_records_loaded: last_input_string.count > 0 =
                not all_records.is_empty
        end

    all_records: DYNAMIC_LIST [STRING]

feature {NONE} -- Implementation

    pending_input: STRING
            -- All input currently 'pending' from the server
        do
            from
                create Result.make (16384)
                read_line
                if not at_end_of_input then
                    Result.append (last_string)
                end
                read_line
            until
                at_end_of_input
            loop
                Result.append (record_separator + last_string)
                read_line
            end
        end

    split_current_record
        do
            current_record := all_records.item.split (field_separator @ 1)
        ensure then
            current_record_exists: current_record /= Void
        end

feature {NONE} -- Implementation - attributes

feature {NONE} -- Hook routine implementations

    split_current_record_on_start: BOOLEAN = False

end
