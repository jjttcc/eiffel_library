indexing
	description: "An input record sequence for a database implementation"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class DB_INPUT_SEQUENCE inherit

	INPUT_RECORD_SEQUENCE

creation

	make

feature -- Initialization

	make (ts: LINKED_LIST[DB_RESULT]) is
		require
			ts_not_void: ts /= Void
		do
			set_tuple_sequence (ts)
		ensure
			tuple_sequence = ts
		end

feature -- Access

	last_double: DOUBLE

	last_real: REAL

	last_integer: INTEGER

	last_character: CHARACTER

	name: STRING is "database input sequence"

	field_index: INTEGER

	record_index: INTEGER is
		do
			Result := tuple_sequence.index
		end

	tuple_sequence: LINKED_LIST[DB_RESULT]

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

	advance_to_next_field is
		do
			field_index := field_index + 1
		end

	advance_to_next_record is
		do
			tuple_sequence.forth
			if not after_last_record then
				tuple ?= tuple_sequence.item.data			
			end
			field_index := 1
		end

	start is
		do
			tuple_sequence.start
			field_index := 1
		end

	discard_current_record is
		do
			advance_to_next_record
		end

feature -- Element change

	set_tuple_sequence(ts: LINKED_LIST[DB_RESULT]) is
		require
			valid_sequence: ts /= Void
		do
			tuple_sequence := ts
			if ts.count > 0 then
				tuple_sequence.start
				check field_index = 1 end
				tuple ?= tuple_sequence.item.data
			end
		ensure
			tuple_sequence = ts
		end

feature -- Input

	read_integer is
		local
			i_ref: INTEGER_REF
			dt: DATE_TIME
		do
			create i_ref
			create dt.make_now
			if tuple.item(field_index).conforms_to(dt) then
				-- Dates must be converted to integers.
				dt ?= tuple.item(field_index)
				last_integer := ((dt.date.year * 10000) +
					(dt.date.month * 100) + dt.date.day)
			elseif tuple.item(field_index).conforms_to(i_ref) then
				i_ref ?= tuple.item(field_index)
				last_integer := i_ref.item
			end
		end

	read_character is
		local
			c_ref: CHARACTER_REF
		do
			create c_ref
			if tuple.item(field_index).conforms_to(c_ref) then
				c_ref ?= tuple.item(field_index)
				last_character := c_ref.item
			end
		end

	read_double is
		local
			d_ref: DOUBLE_REF
		do
			create d_ref
			if tuple.item(field_index).conforms_to(d_ref) then
				d_ref ?= tuple.item(field_index)
				last_double := d_ref.item
			end
		end

	read_real is
		do
			-- Data from database is of type double (is this always
			-- true regardless of RDBMS?).
			read_double
			last_real := last_double.truncated_to_real
		end

feature {NONE} -- Implementation

	tuple: DATABASE_DATA[DATABASE]

invariant

	tuple_sequence /= Void

end -- class DB_INPUT_SEQUENCE
