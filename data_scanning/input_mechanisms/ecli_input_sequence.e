indexing
	description: "An input record sequence for a database implementation %
		%using the ECLI package"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class ECLI_INPUT_SEQUENCE inherit

	DB_INPUT_SEQUENCE

creation

	make

feature -- Initialization

	make (ts: ECLI_STATEMENT) is
		require
			ts_not_void: ts /= Void
		do
			set_tuple_sequence (ts)
		ensure
			tuple_sequence = ts
		end

feature -- Access

	tuple_sequence: ECLI_STATEMENT

	record_index: INTEGER

feature -- Status report

	after_last_record: BOOLEAN is
		do
			Result := tuple_sequence.after
		end

	readable: BOOLEAN is
		do
			Result := not tuple_sequence.off
		end

feature -- Cursor movement

	advance_to_next_record is
		do
			tuple_sequence.forth
			field_index := 1
			record_index := record_index + 1
		end

	start is
		do
			tuple_sequence.start
			field_index := 1
			record_index := 1
			error_occurred := false
		end

feature -- Element change

	set_tuple_sequence(ts: ECLI_STATEMENT) is
		require
			valid_sequence: ts /= Void
		do
			tuple_sequence := ts
		ensure
			tuple_sequence = ts
		end

feature {NONE} -- Implementation

	current_field: ANY is
		do
			Result := tuple_sequence.cursor.item (field_index).item
		end

invariant

	tuple_sequence /= Void

end -- class ECLI_INPUT_SEQUENCE
