indexing
	description:
		"Abstraction that provides a top level data scanning algorithm, %
		%configured by providing different types in the tuple_maker and %
		%value_setters attributes"
	detailed_description:
		"The value_setters attribute must contain instances of descendants %
		%of VALUE_SETTER that will create tuples arranged in the correct %
		%order according to the input format.  For example, if the input %
		%fields are name, address, and telephone number of a PERSON, %
		%value_setters would contain instances of the classes (with names %
		%such as) NAME_SETTER, ADDRESS_SETTER, and TELEPHONE_SETTER, %
		%arranged in that order."
	date: "$Date$";
	revision: "$Revision$"

deferred class DATA_SCANNER inherit

	FACTORY
		redefine
			execute_precondition
		end

feature -- Access

	product: LIST [ANY]
			-- Tuples produced by scanning the input

	error_list: LINKED_LIST [STRING]
			-- Errors that occurred during scanning
			-- errror_list.count = number of errors that occurred

feature -- Basic operations

	execute (arg: NONE) is
			-- Scan input and create tuples from it.
		local
			tuple: ANY
		do
			if error_list = Void then
				!!error_list.make
			end
			from
				create_product
				check product /= Void end
				input_file.start
			invariant
				-- product.count = number_of_records_in (
				--	input_file @ 1 .. input_file @ (input_file.index - 1))
			variant
				input_file.count - input_file.index
			until
				input_file.after
			loop
				from
					tuple_maker.execute (Void)
					tuple := tuple_maker.product
					open_tuple (tuple)
					product.extend (tuple)
					value_setters.start
					check not value_setters.after end
					-- Set first field of tuple:
					value_setters.item.set (input_file, tuple)
					if value_setters.item.error_occurred then
						error_list.extend (value_setters.item.last_error)
					end
					value_setters.forth
				invariant
					-- tuple.number_of_fields_set = value_setters.index - 1
				variant
					value_setters.count - value_setters.index
				until
					value_setters.after
				loop
					skip_field_separator
					value_setters.item.set (input_file, tuple)
					if value_setters.item.error_occurred then
						error_list.extend (value_setters.item.last_error)
					end
					value_setters.forth
				end
				close_tuple (tuple)
				skip_record_separator
			end
		ensure then
			-- product.count = number of records in input_file
		end

feature -- Status report

	execute_precondition: BOOLEAN is
		do
			Result := (tuple_maker /= Void and value_setters /= Void and
				field_separator /= Void and record_separator /= Void and
				input_file /= Void and input_file.exists and
				input_file.readable and not value_setters.empty)
		ensure then
			Result = (tuple_maker /= Void and value_setters /= Void and
				field_separator /= Void and record_separator /= Void and
				input_file /= Void and input_file.exists and
				input_file.readable and not value_setters.empty)
		end

feature -- Access

	tuple_maker: FACTORY
			-- Tuple manufacturer

	value_setters: LIST [VALUE_SETTER]
			-- Used to scan input and set the appropriate tuple fields

	field_separator: STRING
			-- Character(s) that separate each field in the input

	record_separator: STRING
			-- Character(s) that separate each record in the input

	input_file: FILE
			-- Input file or stream

feature -- Element change

	set_tuple_maker (arg: FACTORY) is
		do
			tuple_maker := arg
		end

	set_value_setters (arg: LIST [VALUE_SETTER]) is
		do
			value_setters := arg
		end

	set_field_separator (arg: STRING) is
		do
			field_separator := arg
		end

	set_record_separator (arg: STRING) is
		do
			record_separator := arg
		end

	set_input_file (arg: FILE) is
		do
			input_file := arg
		end

feature {NONE} -- Hook methods

	create_product is
			-- Instantiate product as an effective descendant.
		deferred
		ensure
			product /= Void
		end

	open_tuple (t: ANY) is
			-- Perform any initialization of `t' needed before setting
			-- its fields.
		require
			t /= Void
		do
		end

	close_tuple (t: ANY) is
			-- Perform any close/clean-up of `t' needed after setting
			-- its fields.
		require
			t /= Void
		do
		end

feature {NONE}

	skip_field_separator is
			-- Skip over the field separator in the input.
			-- Can be overridden in a descendant for more sophisticated
			-- behavior.
		local
			i: INTEGER
		do
			from
				i := 1
			variant
				field_separator.count + 1 - i
			until
				i > field_separator.count
			loop
				-- If field_separator @ i is a tab or space, it will have
				-- been eaten in the last read_x call.  If it's something
				-- else, then the character still needs to be eaten.
				if
					not (field_separator @ i = '%T' or
						field_separator @ i = ' ')
				then
					input_file.read_character
					if
						input_file.last_character /= field_separator @ i
					then
						error_list.extend (
								"Incorrect field separator detected.")
					end
				end
				i := i + 1
			end
		end

	skip_record_separator is
			-- Skip over the record separator in the input.
			-- Can be overridden in a descendant for more sophisticated
			-- behavior.
		local
			i: INTEGER
		do
			from
				i := 1
			variant
				record_separator.count + 1 - i
			until
				i > record_separator.count
			loop
				-- If record_separator @ i is a tab or space or newline,
				-- it will have been eaten in the last read_x call.  If it's
				-- something else, then the character still needs to be eaten.
				if
					not (record_separator @ i = '%T' or
						record_separator @ i = ' ' or
						record_separator @ i = '%N')
				then
					input_file.read_character
					if
						input_file.last_character /= record_separator @ i
					then
						error_list.extend (
								"Incorrect record separator detected.")
					end
				end
				i := i + 1
			end
		end

end -- class DATA_SCANNER
