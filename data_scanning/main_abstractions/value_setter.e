indexing
	description:
		"Abstraction that scans input and uses it to set the appropriate %
		%field of a `tuple'";
	detailed_description:
		"Each descendant class will, in the set procedure, set the %
		%appropriate field of the tuple according to the type of the class. %
		%For example, a CLOSE_SETTER in a financial analysis application %
		%will set the close field of the tuple.	Or, an application that %
		%deals with people or other objects that have names would use a %
		%NAME_SETTER to set the name field of a tuple."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

deferred class VALUE_SETTER inherit

	EXCEPTIONS
		export
			{NONE} all
		end

	GENERAL_UTILITIES
		export
			{NONE} all
		end

feature -- Basic operations

	set (stream: INPUT_SEQUENCE; tuple: ANY) is
			-- Set the appropriate field of tuple using `stream' as input.
			-- If `unrecoverable_error' occurs, no action is taken.
		require
			args_not_void: stream /= Void and tuple /= Void
			stream_readable: stream.readable
		do
			error_occurred := false
			unrecoverable_error := false
			read_value (stream)
			if
				not is_dummy and not error_occurred
			then
				do_set (stream, tuple)
			end
		rescue
			unrecoverable_error := true
			handle_input_error (concatenation(<<"Error occurred while ",
				"reading ", stream.name, ": ", meaning (exception)>>), Void)
			log_error (last_error)
		end

feature -- Access

	last_error: STRING
			-- Last error that occured

	error_occurred: BOOLEAN
			-- Did an error occur on the last scan?

	unrecoverable_error: BOOLEAN
			-- If `error_occurred', was it unrecoverable?

	is_dummy: BOOLEAN
			-- Is the field associated with this value setter to be
			-- treated as a dummy field - not set in the actual tuple?

feature -- Element change

	set_dummyness (b: BOOLEAN) is
			-- Set whether the associated field is to be regarded as a dummy.
		do
			is_dummy := b
		ensure
			set_to_b: is_dummy = b
		end

feature {NONE} -- Hook methods

	read_value (stream: INPUT_SEQUENCE) is
			-- Read the next value (char or integer or etc.) from `stream'.
		deferred
		end

	do_set (stream: INPUT_SEQUENCE; tuple: ANY) is
			-- Set appropriate field of `tuple' according
			-- to the last value read in stream.
		require
			not is_dummy and not error_occurred
		deferred
		end

feature {NONE} -- Utility

	handle_input_error (main_msg, msg2: STRING) is
			-- Instantiate last_error, append main_msg (and msg2 if
			-- not Void) to last_error, and set error_occurred to True.
		require
			main_msg /= Void
		do
			create last_error.make (128)
			last_error.append (main_msg)
			if msg2 /= Void then
				last_error.append (msg2)
			end
			error_occurred := True
		ensure
			error_occurred: error_occurred
			msg_appended:
				last_error /= Void and last_error.count >= main_msg.count
		end

invariant

	error_relationship: unrecoverable_error implies error_occurred

end -- class VALUE_SETTER
