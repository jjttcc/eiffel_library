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
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class

	VALUE_SETTER

feature {FACTORY} -- Basic operations

	set (stream: BILINEAR_INPUT_SEQUENCE; tuple: ANY) is
			-- Set the appropriate field of tuple using `stream' as input.
		require
			args_not_void: stream /= Void and tuple /= Void
			stream_readable: stream.readable
		do
			error_occurred := false
			read_value (stream)
			if
				not is_dummy and not error_occurred
			then
				do_set (stream, tuple)
			end
		end

feature {FACTORY} -- Access

	last_error: STRING
			-- Last error that occured

	error_occurred: BOOLEAN
			-- Did an error occur on the last scan?

	is_dummy: BOOLEAN
			-- Is the field associated with this value setter to be
			-- treated as a dummy field - not set in the actual tuple?

feature {FACTORY} -- Element change

	set_dummyness (b: BOOLEAN) is
			-- Set whether the associated field is to be regarded as a dummy.
		do
			is_dummy := b
		ensure
			set_to_b: is_dummy = b
		end

feature {NONE} -- Hook methods

	read_value (stream: BILINEAR_INPUT_SEQUENCE) is
			-- Read the next value (char or integer or etc.) from `stream'.
		deferred
		end

	do_set (stream: BILINEAR_INPUT_SEQUENCE; tuple: ANY) is
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
			!!last_error.make (128)
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

end -- class VALUE_SETTER
