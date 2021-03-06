note
	description: "Input record sequences for a database implementation"
	author: "Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class DB_INPUT_SEQUENCE inherit

	INPUT_RECORD_SEQUENCE

feature -- Access

	last_double: DOUBLE

	last_real: REAL

	last_integer: INTEGER

	last_character: CHARACTER

	last_string: STRING

	last_date: DATE

	name: STRING = "database input sequence"

	field_index: INTEGER

feature -- Status report

	last_error_fatal: BOOLEAN

	is_open: BOOLEAN
			-- Is the input sequence open for use?
		deferred
		end

feature -- Status setting

	close
			-- Perform any needed cleanup operations.  Should be called
			-- after input facilities have finished being used.
		require
			open: is_open
		deferred
		ensure
			closed: not is_open
		end

feature -- Cursor movement

	advance_to_next_field
		do
			field_index := field_index + 1
		end

	discard_current_record
		do
			advance_to_next_record
		end

feature -- Input

	read_integer
		local
			i_ref: INTEGER_REF
			dt: DATE_TIME
		do
			reset_error_state
			i_ref ?= current_field
			if i_ref /= Void then
				last_integer := i_ref.item
			else
				-- Dates currently must be converted to integers.
				dt ?= current_field
				if dt /= Void then
					last_integer := ((dt.date.year * 10000) +
						(dt.date.month * 100) + dt.date.day)
				else
					error_occurred := True
					last_error_fatal := True
					error_string :=
						"Database error: wrong data type - integer expected"
				end
			end
		end

	read_character
		local
			c_ref: CHARACTER_REF
		do
			reset_error_state
			c_ref ?= current_field
			if c_ref /= Void then
				last_character := c_ref.item
			else
				error_occurred := True
				last_error_fatal := True
				error_string :=
					"Database error: wrong data type - character expected"
			end
		end

	read_string
		local
			string: STRING
		do
			reset_error_state
			string ?= current_field
			if string /= Void then
				last_string := string
			else
				error_occurred := True
				last_error_fatal := True
				error_string :=
					"Database error: wrong data type - string expected"
			end
		end

	read_date
		local
			date: DT_DATE
		do
			reset_error_state
			date ?= current_field
			if date /= Void then
				create last_date.make (date.year, date.month, date.day)
			else
				error_occurred := True
				last_error_fatal := True
				error_string :=
					"Database error: wrong data type - date expected"
			end
		end

	read_double
		local
			d_ref: DOUBLE_REF
		do
			reset_error_state
			d_ref ?= current_field
			if d_ref /= Void then
				last_double := d_ref.item
			else
				error_occurred := True
				last_error_fatal := True
				error_string :=
					"Database error: wrong data type - double expected"
			end
		end

	read_real
		do
			-- Default implementation - for databases where real and double
			-- is the same type
			read_double
			last_real := last_double.truncated_to_real
		end

feature {NONE} -- Implementation

	current_field: ANY
			-- Current field value
		deferred
		end

	reset_error_state
		do
			error_occurred := False
			last_error_fatal := False
			error_string := ""
		end

end -- class DB_INPUT_SEQUENCE
