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
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class DATA_SCANNER inherit

	FACTORY

feature -- Initialization

	make (in: like input; tm: like tuple_maker; vs: like value_setters) is
		require
			args_not_void: in /= Void and tm /= Void and vs /= Void
			vs_not_empty: not vs.empty
		do
			input := in
			tuple_maker := tm
			value_setters := vs
		ensure
			set: input = in and tuple_maker = tm and value_setters = vs
		end

feature -- Access

	product: COLLECTION [ANY]
			-- Tuples produced by scanning the input

	error_list: LINKED_LIST [STRING]
			-- Errors that occurred during scanning
			-- errror_list.count = number of errors that occurred

	last_error_fatal: BOOLEAN
			-- Was the last error that occurred during scanning fatal,
			-- meaning that scanning can't continue?

	tuple_maker: FACTORY
			-- Tuple manufacturer

	value_setters: LIST [VALUE_SETTER]
			-- Used to scan input and set the appropriate tuple fields

	input: INPUT_SEQUENCE
			-- Sequence used for input

feature -- Element change

	set_tuple_maker (arg: FACTORY) is
			-- Set tuple_maker to `arg'.
		require
			arg /= Void
		do
			tuple_maker := arg
		ensure
			tuple_maker_set: tuple_maker = arg and tuple_maker /= Void
		end

	set_value_setters (arg: LIST [VALUE_SETTER]) is
			-- Set value_setters to `arg'.
		require
			arg /= Void
		do
			value_setters := arg
		ensure
			value_setters_set: value_setters = arg and value_setters /= Void
		end

	set_input (arg: like input) is
			-- Set input to `arg'.
		require
			arg /= Void
		do
			input := arg
		ensure
			input_set: input = arg and input /= Void
		end

feature -- Basic operations

	execute is
			-- Scan input and create tuples from it.
			-- `input' must not be Void.
		do
			if error_list = Void then
				!!error_list.make
			end
			from
				create_product
				check product /= Void end
				input.start
			invariant
				-- product.count = number_of_records_in (
				--	input @ 1 .. input @ (input.index - 1))
			variant
				input.count - input.index + 1
			until
				input.after or last_error_fatal
			loop
				make_tuple
				if not last_error_fatal then
					advance_to_next_record
				end
			end
			if last_error_fatal then
				handle_fatal_error
			end
		ensure then
			-- product.count = number of records in input
			errlist_not_void: error_list /= Void
		end

feature {NONE} -- Hook methods

	create_product is
			-- Instantiate product as an effective descendant.
		deferred
		ensure
			product /= Void
		end

	make_tuple is
			-- Create a tuple and initialize it with the data from
			-- the current record in `input'.  Default implementation.
		local
			tuple: ANY
		do
			tuple_maker.execute
			tuple := tuple_maker.product
			open_tuple (tuple)
			add_tuple (tuple)
			from
				value_setters.start
				check not value_setters.after end
				-- Set first field of tuple:
				value_setters.item.set (input, tuple)
				if value_setters.item.error_occurred then
					error_list.extend (value_setters.item.last_error)
				end
				value_setters.forth
			invariant
				-- tuple.number_of_fields_set = value_setters.index - 1
			variant
				value_setters.count - value_setters.index + 1
			until
				value_setters.after
			loop
				advance_to_next_field
				value_setters.item.set (input, tuple)
				if value_setters.item.error_occurred then
					error_list.extend (value_setters.item.last_error)
				end
				value_setters.forth
			end
			close_tuple (tuple)
		ensure
			--one_more: product.count = old product.count + 1 or
			--		scanning_error_occurred
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

	add_tuple (t: ANY) is
			-- Add tuple to product - redefine if not needed.
		do
			product.extend (t)
		end

	handle_fatal_error is
			-- Clean up after fatal error.  Default implementation -
			-- remove all elements of product.
		do
			product.wipe_out
		end

feature {NONE}

	advance_to_next_field is
			-- Advance to the next field in the input.
			-- Call `input.advance_to_next_field' by default.  Can be
			-- overridden in a descendant if different behavior is needed.
		local
		do
			input.advance_to_next_field
			if input.error_occurred then
				error_list.extend (input.error_string)
			end
		end

	advance_to_next_record is
			-- Advance to the next record in the input.
			-- Call `input.advance_to_next_record' by default.  Can be
			-- overridden in a descendant if different behavior is needed.
		do
			input.advance_to_next_record
			if input.error_occurred then
				error_list.extend (input.error_string)
			end
		end

	scanning_error_occurred: BOOLEAN
			-- Did an error occur during the last scan (in make_tuple)?

invariant

	properties_not_void:
		tuple_maker /= Void and value_setters /= Void
	value_setters_not_empty: not value_setters.empty

end -- class DATA_SCANNER
