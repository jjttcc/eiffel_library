note

	description:
		"An input sequence that includes the concept of records and fields"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class INPUT_RECORD_SEQUENCE inherit

	INPUT_SEQUENCE

feature -- Access

	field_index: INTEGER
			-- Index of the current field - starts at 1.
		require
			readable: open_for_reading
		deferred
		end

	record_index: INTEGER
			-- Index of the current record - starts at 1.
		require
			readable: open_for_reading
		deferred
		end

	field_count: INTEGER
			-- Number of fields per record
		require
			readable: open_for_reading
		deferred
		end

feature -- Status report

	after_last_record: BOOLEAN
			-- Is the cursor after the last record?
		deferred
		end

	last_error_fatal: BOOLEAN
			-- Was the last error unrecoverable?
		deferred
		end

	open_for_reading: BOOLEAN
			-- Is Current in a readable state?
		do
			Result := True
		end

feature -- Cursor movement

	start
			-- Place cursor on the first record.
		require
			readable: open_for_reading
		deferred
		ensure
			indices_at_1: readable implies
				(field_index = 1 and record_index = 1)
		end

	advance_to_next_record
			-- Advance the cursor to the next record.
		require
			readable: open_for_reading
			not_after: not after_last_record
		deferred
		ensure
			record_index_incremented: readable implies
				(record_index = old record_index + 1)
		end

	advance_to_next_field
			-- Advance the cursor to the next field.
		require
			readable: open_for_reading
			not_after: not after_last_record
			field_index_valid: field_index <= field_count
		deferred
		ensure
			field_index_incremented: readable implies
				(field_index = old field_index + 1)
		end

	discard_current_record
			-- Discard the current record - place cursor on the next
			-- record.
		require
			readable: open_for_reading
			not_after: not after_last_record
		deferred
		ensure
			record_index_incremented: readable implies
				(record_index = old record_index + 1)
		end

end -- class INPUT_RECORD_SEQUENCE
