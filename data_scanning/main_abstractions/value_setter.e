indexing
	description:
		"Abstraction that scans input and uses it to set the appropriate %
		%field of a MARKET_TUPLE";
	detailed_description:
		"Each descendant class will set the appropriate field of the tuple %
		%according to the type of the class.  For example, a CLOSE_SETTER %
		%will set the close field of the tuple.  Thus, the instances of %
		%descendants of this class that are used to create tuples must %
		%be arranged in the correct order according to the input format. %
		%For example, if the input field format is open, high, low, close, %
		%there must be four class instances of types OPEN_SETTER, %
		%HIGH_SETTER, LOW_SETTER, and CLOSE_SETTER, respectively."
	date: "$Date$";
	revision: "$Revision$"

deferred class VALUE_SETTER inherit

	MATH_CONSTANTS
		export {NONE}
			all
		end

feature {FACTORY} -- Basic operations

	set (stream: IO_MEDIUM; tuple: MARKET_TUPLE) is
			-- Set the appropriate field of tuple using `stream' as input.
		require
			args_not_void: stream /= Void and tuple /= Void
			stream_readable: stream.exists and then stream.readable
		do
			error_occurred := false
			do_set (stream, tuple)
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

feature {NONE}

	do_set (stream: IO_MEDIUM; tuple: MARKET_TUPLE) is
			-- Hook method to do the actual setting
		require
			not error_occurred
		deferred
		end

end -- class VALUE_SETTER
