indexing
	description: "An input sequence for a database implementation"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"
	note: "Note: Shouldn't this inherit from INPUT_SEQUENCE?"

class DB_INPUT_SEQUENCE inherit

	INPUT_SEQUENCE

feature -- Change

	set_tuple_sequence(ts: LINKED_LIST[DB_RESULT]) is
		require
			valid_sequence: ts /= void
		do
			tuple_sequence := ts
			if ts.count > 0 then
				tuple_sequence.start
				tuple ?= tuple_sequence.item.data
				field_index := 1	
			end
		ensure
			tuple_sequence = ts
		end

feature --

	advance_to_next_field is
		do
			field_index := field_index + 1
		end

	advance_to_next_record is
		do
			forth
			if not after then
				tuple ?= tuple_sequence.item.data			
			end
			field_index := 1
		end

	back is
		do
			tuple_sequence.back
		end

	forth is
		do
			tuple_sequence.forth
		end

	finish is
		do
			tuple_sequence.finish
		end

	start is
		do
			tuple_sequence.start
		end

	read_integer is
		local
			i_ref: INTEGER_REF
			dt: DATE_TIME
		do
			create i_ref
			create dt.make_now
			if tuple.item(field_index).conforms_to(dt) then -- dates must be converted to integers
				dt ?= tuple.item(field_index)
				last_integer := ((dt.date.year * 10000) + (dt.date.month * 100) + dt.date.day)
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
			read_double -- data from database is of type double (is this always true regardless of RDBMS?)
			last_real := last_double.truncated_to_real
		end

feature -- Access

	after: BOOLEAN is
		do
			Result := tuple_sequence.after
		end

	before: BOOLEAN is
		do
			Result := tuple_sequence.before
		end

	empty: BOOLEAN is
		do
			Result := tuple_sequence.empty
		end


	readable: BOOLEAN is
		do
			Result := not tuple_sequence.off
		end

	last_double: DOUBLE

	last_real: REAL

	last_integer: INTEGER

	last_character: CHARACTER

	index: INTEGER is
		do
			Result := tuple_sequence.index
		end

	count: INTEGER is
		do
			Result := tuple_sequence.count
		end

	name: STRING is "database input sequence"

feature {NONE} -- Implementation

	tuple_sequence: LINKED_LIST[DB_RESULT]
	tuple: DATABASE_DATA[DATABASE]
	field_index: INTEGER

end -- class DB_INPUT_SEQUENCE
