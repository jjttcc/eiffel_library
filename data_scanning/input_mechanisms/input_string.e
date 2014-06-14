note
	description:
		"Input-record sequences that split a string into records and %
		%fields according to specified field and record separators"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class INPUT_STRING inherit

	INPUT_RECORD_SEQUENCE

creation

	make

feature {NONE} -- Initialization

	make (s, field_separator, record_separator: STRING)
			-- Use `field_separator' and `record_separator' to produce
			-- `contents' from `s' by splitting `s' into fields and
			-- records.
		require
			args_not_empty: s /= Void and field_separator /= Void and
				record_separator /= Void and then (
				not s.is_empty and
				not field_separator.is_empty and
				not record_separator.is_empty)
			separators_differ: not field_separator.is_equal (record_separator)
		local
			records: LIST [STRING]
			splitter: expanded STRING_UTILITIES
		do
			splitter.set_target (s)
			records := splitter.tokens (record_separator)
			create contents.make (0)
			if not records.is_empty then
				make_contents (records, field_separator)
			end
			date_field_separator := "-"
		ensure
			date_sep_set: date_field_separator.is_equal ("-")
			at_least_one_field:
				contents.count > 0 and then contents.first.count > 0
		end

	make_contents (records: LIST [STRING]; field_separator: STRING)
		local
			splitter: expanded STRING_UTILITIES
			fields: ARRAYED_LIST [STRING]
		do
			from
				records.start
				splitter.set_target (records.item)
				contents.extend (splitter.tokens (field_separator))
				field_count := contents.last.count
				records.forth
			until
				-- The last item will be empty, so skip it.
				records.islast
			loop
				splitter.set_target (records.item)
				fields := splitter.tokens (field_separator)
				if fields.count /= field_count then
					make_error ("Wrong field count at record " +
						records.index.out + " - skipping current record", True)
				else
					contents.extend (fields)
				end
				records.forth
			end
		end

feature -- Access

	contents: ARRAYED_LIST [ARRAYED_LIST [STRING]]
			-- The contents for processing, split into records and fields

feature -- Access

	date_field_separator: STRING

feature -- Access

	last_string: STRING

	last_character: CHARACTER

	last_double: DOUBLE

	last_integer: INTEGER

	last_date: DATE

	field_index: INTEGER
		do
			if readable then
				Result := contents.item.index
			end
		end

	record_index: INTEGER
		do
			Result := contents.index
		end

	field_count: INTEGER

	name: STRING = "Input-sequence as a string"

feature -- Status report

	after_last_record: BOOLEAN
		do
			Result := contents.after
		end

	last_error_fatal: BOOLEAN

	readable: BOOLEAN
		do
			Result := not contents.off and then not contents.item.off
		ensure
			definition:
				Result = not contents.off and then not contents.item.off
		end

feature -- Cursor movement

	advance_to_next_field
		do
			last_error_fatal := False
			error_occurred := False
			contents.item.forth
		end

	advance_to_next_record
		do
			last_error_fatal := False
			error_occurred := False
			contents.forth
			if not contents.exhausted then
				contents.item.start
			end
		end

	discard_current_record
		do
			advance_to_next_record
		end

	start
		do
			contents.start
			contents.item.start
		end

feature -- Element change

	set_date_field_separator (arg: STRING)
			-- Set `date_field_separator' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			date_field_separator := arg
		ensure
			date_field_separator_set: date_field_separator = arg and
				date_field_separator /= Void
		end

feature -- Input

	read_string
		do
			error_occurred := False
			last_string := contents.item.item
		end

	read_character
		do
			error_occurred := False
			last_character := '%U'
			if not contents.item.item.is_empty then
				last_character := contents.item.item @ 1
			end
		end

	read_integer
		local
			s: STRING
		do
			error_occurred := False
			s := contents.item.item
			if s.is_integer then
				last_integer := s.to_integer
			else
				make_error ("Invalid field value - integer expected, %
					%got: " + s + "%N", False)
			end
		end

	read_real
		local
			s: STRING
		do
			error_occurred := False
			s := contents.item.item
			if s.is_real then
				last_double := s.to_real
			else
				make_error ("Invalid field value - real expected, %
					%got: " + s + "%N", False)
			end
		end

	read_double
		local
			s: STRING
		do
			error_occurred := False
			s := contents.item.item
			if s.is_double then
				last_double := s.to_double
			else
				make_error ("Invalid field value - double expected, %
					%got: " + s + "%N", False)
			end
		end

	read_date
		local
			splitter: expanded STRING_UTILITIES
			ymd: ARRAY [STRING]
			y, m, d: INTEGER
		do
			error_occurred := False
			last_date := Void
			if not contents.item.item.is_empty then
				splitter.set_target (contents.item.item)
				ymd := splitter.tokens (date_field_separator)
			end
			if ymd /= Void then
				if ymd.count /= 3 then
					make_error ("Wrong number of sub-fields in date %
						%field (" + contents.item.item +
						"): " + ymd.count.out + "%NUsing default %
						%date setting%N", False)
					create last_date.make_by_days (0)
				else
					if
						ymd.item (1).is_integer and
						ymd.item (2).is_integer and
						ymd.item (3).is_integer
					then
						y := ymd.item (1).to_integer
						m := ymd.item (2).to_integer
						d := ymd.item (3).to_integer
						if
							work_date.is_correct_date (y, m, d)
						then
							create last_date.make (y, m, d)
						else
							make_error ("Incorrect date field", False)
						end
					else
						make_error ("Date field has illegal non-integer value",
							False)
					end
				end
			end
		end

feature {NONE} -- Implementation

	work_date: DATE
		once
			create Result.make_now
		end

	make_error (s: STRING; append: BOOLEAN)
			-- Set `error_string' to `s' - if append, append `s' to end
			-- of `error_string'.
		do
			if not append then error_string := Void end
			if error_string = Void then
				create error_string.make (0)
			end
			error_string.append (s +  index_info + "%N")
			error_occurred := True
		ensure
			error_occurred: error_occurred
			error_string_exists: error_string /= Void
		end

	index_info: STRING
		do
			if contents.valid_index (contents.index) then
				Result := "record " + contents.index.out
				if contents.item.valid_index (contents.item.index) then
					Result.append (", field " + contents.item.index.out)
				end
			else
				Result := ""
			end
		end

invariant

	contents_exist: contents /= Void
	field_count_when_empty: contents.is_empty implies field_count = 0
	date_field_separator_exists: date_field_separator /= Void

end
