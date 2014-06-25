note
	description: "Input record sequences for a database implementation %
		%using the ECLI package"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class ECLI_INPUT_SEQUENCE inherit

	DB_INPUT_SEQUENCE

creation

	make

feature -- Initialization

	make (ts: ECLI_STATEMENT)
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

	field_count: INTEGER
		do
			Result := tuple_sequence.result_columns_count
		end

feature -- Status report

	after_last_record: BOOLEAN
		do
			Result := tuple_sequence.after
		end

	readable: BOOLEAN
		do
			Result := not tuple_sequence.off
		end

	is_open: BOOLEAN
		do
			Result := not tuple_sequence.is_closed
		end

feature -- Status setting

	close
		do
			tuple_sequence.close
		end

feature -- Cursor movement

	advance_to_next_record
		do
			tuple_sequence.forth
			field_index := 1
			record_index := record_index + 1
		end

	start
		do
			tuple_sequence.start
			field_index := 1
			record_index := 1
			error_occurred := False
		end

feature -- Element change

	set_tuple_sequence (ts: ECLI_STATEMENT)
		require
			valid_sequence: ts /= Void
		do
			tuple_sequence := ts
		ensure
			tuple_sequence = ts
		end

feature {NONE} -- Implementation

	current_field: ANY
		local
			v: ECLI_VALUE
		do
			v := tuple_sequence.results.item (field_index)
			if v /= Void and then not v.is_null then
--!!!				Result := v.item
--!!!!???!!!![14.05] -- Check if this change/update is correct:
				Result := v
			end
		end

invariant

	tuples_not_void: tuple_sequence /= Void

end -- class ECLI_INPUT_SEQUENCE
