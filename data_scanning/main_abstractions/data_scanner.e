indexing
	description:
		"Abstraction that provides a top level data scanning algorithm, %
		%configured by providing different types in the tuple_maker and %
		%value_setters attributes"
	detailed_description:
		"The value_setters attribute must contain instances of descendants %
		%of VALUE_SETTER that will create tuples arranged in the correct %
		%order according to the input format.  For example, if the input %
		%fields are name, address, and telephone number of a person class, %
		%value_setters would contain instances of the classes (with names %
		%such as) name_setter, address_setter, and telephone_setter, %
		%arranged in that order."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class DATA_SCANNER inherit

	FACTORY
		redefine
			execute_precondition
		end

feature -- Initialization

	make (in: like input; tm: like tuple_maker; vs: like value_setters) is
		require
			args_not_void: in /= Void and tm /= Void and vs /= Void
			vs_not_empty: not vs.is_empty
		do
			input := in
			tuple_maker := tm
			value_setters := vs
		ensure
			set: input = in and tuple_maker = tm and value_setters = vs
			start_input: start_input
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

	input: INPUT_RECORD_SEQUENCE
			-- Sequence used for input

feature -- Status report

	strict_error_checking: BOOLEAN
			-- Should all records with errors be unconditionally discarded?

	execute_precondition: BOOLEAN is
		do
			Result := input /= Void and then input.readable
		ensure then
			Result = (input /= Void and then input.readable)
		end

	start_input: BOOLEAN is
			-- Is 'input.start' to be called by `execute' before
			-- scanning the data?
		do
			Result := not do_not_start_input_before_scanning
		end

feature -- Status setting

	turn_start_input_off is
			-- Set `start_input' to False.
		do
			do_not_start_input_before_scanning := True
		ensure
			not_start_input: not start_input
		end

	turn_start_input_on is
			-- Set `start_input' to True.
		do
			do_not_start_input_before_scanning := False
		ensure
			start_input: start_input
		end

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

	set_strict_error_checking (arg: BOOLEAN) is
			-- Set strict_error_checking to `arg'.
		do
			strict_error_checking := arg
		ensure
			strict_error_checking_set: strict_error_checking = arg
		end

feature -- Basic operations

	execute is
			-- Scan input and create tuples from it.  If `start_input',
			-- call 'input.start' before scanning.
		do
			if error_list = Void then
				create error_list.make
			end
			from
				create_product
				check product /= Void end
				if start_input then
					input.start
				end
				check
					input_valid: input /= Void and then
					(input.readable or else input.after_last_record)
				end
				if
					start_input and then value_setters_used and
					input.field_count /= value_setters.count
				then
					-- (If not `start_input', assume that the field count
					-- for the current tradable was already checked the
					-- first time it was read [when `start_input' was true].)
					last_error_fatal := True
					error_in_current_tuple := True
					error_list.extend (Wrong_field_count_message)
				end
			invariant
				-- product.count = number_of_records_in (
				--	input @ 1 .. input @ (input.record_index - 1))
			until
				input.after_last_record or last_error_fatal
			loop
				make_tuple
				if error_in_current_tuple then
					handle_last_error
				end
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
			error_in_current_tuple := False
			discard_current_tuple := False
			tuple_maker.execute
			tuple := tuple_maker.product
			open_tuple (tuple)
			from
				value_setters.start
				check not value_setters.after end
				-- Set first field of tuple:
				value_setters.item.set (input, tuple)
				if value_setters.item.error_occurred then
					handle_error_for_current_tuple
				end
				value_setters.forth
			invariant
				-- tuple.number_of_fields_set = value_setters.index - 1
			variant
				value_setters.count - value_setters.index + 1
			until
				value_setters.after or discard_current_tuple
			loop
				advance_to_next_field
				if not discard_current_tuple then
					value_setters.item.set (input, tuple)
					if value_setters.item.error_occurred then
						handle_error_for_current_tuple
					end
				end
				value_setters.forth
			end
			do_last_error_check (tuple)
			if not discard_current_tuple then
				close_tuple (tuple)
				add_tuple (tuple)
			else
				discard_tuple (tuple)
			end
		ensure
			--one_more: product.count = old product.count + 1 or
			--		discard_current_tuple
		end

	value_setters_used: BOOLEAN is
			-- Is `value_setters' used?  (Will be True if `make_tuple' is
			-- not redefined.)
		once
			Result := True	-- Redefine if they are not used.
		end

	open_tuple (t: ANY) is
			-- Perform any initialization of `t' needed before setting
			-- its fields.
		require
			t /= Void and not error_in_current_tuple
		do
		end

	do_last_error_check (t: ANY) is
			-- Perform final check for errors before closing the current
			-- tuple.
		do
		end

	close_tuple (t: ANY) is
			-- Perform any close/clean-up of `t' needed after setting
			-- its fields.
		require
			tuple_ok: t /= Void and not discard_current_tuple
		do
		end

	add_tuple (t: ANY) is
			-- Add tuple to product - redefine if not needed.
		require
			tuple_ok: t /= Void and not discard_current_tuple
		do
			product.extend (t)
		end

	discard_tuple (t: ANY) is
			-- Take appropriate action to discard the current tuple in
			-- response to an unrecoverable scanning error.
		require
			not_ok: discard_current_tuple
		do
		end

	handle_fatal_error is
			-- Clean up after fatal error.  Default implementation -
			-- remove all elements of product.
		do
			product.wipe_out
		end

	handle_last_error is
			-- Do any processing needed to handle errors that occurred
			-- while scanning the current tuple.
		do
		end

feature {NONE}

	advance_to_next_field is
			-- Advance to the next field in the input.
			-- Call `input.advance_to_next_field' by default.  Can be
			-- overridden in a descendant if different behavior is needed.
		do
			input.advance_to_next_field
			if input.error_occurred then
				error_list.extend (input.error_string)
				discard_current_tuple := True
				error_in_current_tuple := True
				if input.last_error_fatal then
					last_error_fatal := True
				end
			end
		end

	advance_to_next_record is
			-- Advance to the next record in the input.
			-- Call `input.advance_to_next_record' by default.  Can be
			-- overridden in a descendant if different behavior is needed.
		do
			if not discard_current_tuple then
				input.advance_to_next_record
			else
				-- When discard_current_tuple, input may be at the beginning
				-- of the current record rather than at the end (signified
				-- by "value_setters.index = 2") -
				-- input.advance_to_next_record may not work as expected in
				-- this case.
				input.discard_current_record
			end
			if input.error_occurred then
				error_list.extend (input.error_string)
				if input.last_error_fatal then
					last_error_fatal := True
				end
			end
		end

	handle_error_for_current_tuple is
			-- Add the current error to `error_list' and set internal
			-- error status variables.
		do
			error_list.extend (value_setters.item.last_error)
			error_in_current_tuple := True
			if
				value_setters.item.unrecoverable_error or
				strict_error_checking
			then
				discard_current_tuple := True
			end
		end

	error_in_current_tuple: BOOLEAN
			-- Was an error encountered while scanning the current tuple?

	discard_current_tuple: BOOLEAN
			-- Should the current tuple be discarded due to incorrect or
			-- corrupted data?

feature {NONE} -- Implementation

	do_not_start_input_before_scanning: BOOLEAN
			-- Do not call input.start before calling scanner.execute?

feature {NONE} -- Implementation constants

	Wrong_field_count_message: STRING is
			-- Error message for initial field count check - redefine if needed
		once
			Result := "Wrong number of fields in first record."
		end

invariant

	properties_not_void: tuple_maker /= Void and
		value_setters_used implies value_setters /= Void
	value_setters_not_empty_if_used: value_setters_used implies
		not value_setters.is_empty

end -- class DATA_SCANNER
