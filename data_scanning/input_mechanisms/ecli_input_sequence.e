indexing
	description: "An input record sequence for a database implementation %
		%using the ECLI package"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class ECLI_INPUT_SEQUENCE inherit

	DB_INPUT_SEQUENCE

creation

	make

feature -- Initialization

	make (ts: ECLI_STATEMENT) is
		require
			ts_valid: ts /= Void and not ts.is_closed
		do
			set_tuple_sequence (ts)
		ensure
			tuple_sequence_set: tuple_sequence = ts
			open: is_open
		end

feature -- Access

	tuple_sequence: ECLI_STATEMENT

	record_index: INTEGER

	field_count: INTEGER is
		do
			Result := tuple_sequence.result_column_count
		end

feature -- Status report

	after_last_record: BOOLEAN is
		do
			Result := tuple_sequence.after
		end

	readable: BOOLEAN is
		do
			Result := not tuple_sequence.off
		end

	is_open: BOOLEAN is
		do
			Result := not tuple_sequence.is_closed
		end

feature -- Status setting

	close is
		do
			tuple_sequence.close
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
			error_occurred := False
		end

feature -- Element change

	set_tuple_sequence (ts: ECLI_STATEMENT) is
		require
			valid_sequence: ts /= Void
		do
			tuple_sequence := ts
		ensure
			tuple_sequence = ts
		end

feature {NONE} -- Implementation

	current_field: ANY is
		local
			v: ECLI_VALUE
		do
			v := tuple_sequence.cursor.item (field_index)
			if v /= Void and then not v.is_null then
				Result := v.item
			end
		end

invariant

	tuples_not_void: tuple_sequence /= Void

end -- class ECLI_INPUT_SEQUENCE
