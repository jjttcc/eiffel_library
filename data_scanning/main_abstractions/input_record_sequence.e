indexing

	description:
		"An input sequence that includes the concept of records and fields"
	status: "Copyright 1999 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class INPUT_RECORD_SEQUENCE inherit

	INPUT_SEQUENCE

feature -- Access

	field_index: INTEGER is
			-- Index of the current field - starts at 1.
		deferred
		end

	record_index: INTEGER is
			-- Index of the current record - starts at 1.
		deferred
		end


feature -- Status report

	after_last_record: BOOLEAN is
			-- Is the cursor after the last record?
		deferred
		end

feature -- Cursor movement

	start is
			-- Place cursor on the first record.
		deferred
		ensure
			indices_at_1: field_index = 1 and record_index = 1
		end

	advance_to_next_record is
			-- Advance the cursor to the next record.
		require
			not_after: not after_last_record
		deferred
		ensure
			record_index_incremented: record_index = old record_index + 1
		end

	advance_to_next_field is
			-- Advance the cursor to the next field.
		require
			not_after: not after_last_record
		deferred
		ensure
			field_index_incremented: field_index = old field_index + 1
		end

	discard_current_record is
			-- Discard the current record - place cursor on the next
			-- record.
		require
			not_after: not after_last_record
		deferred
		ensure
			record_index_incremented: record_index = old record_index + 1
		end

end -- class INPUT_RECORD_SEQUENCE
