indexing
	description:
		"Abstraction that scans input and sets the appropriate field of %
		%a MARKET_TUPLE, according to the contents of an input field";
	detailed_description:
		"Each descendant class will set the appropriate field of the tuple %
		%according to the type of the class.  For example, a CLOSE_SETTER %
		%will set the close field of the tuple."
	date: "$Date$";
	revision: "$Revision$"

deferred class 
	VALUE_SETTER

feature -- Basic operations

	set (stream: IO_MEDIUM; tuple: MARKET_TUPLE) is
			-- Set the appropriate field of tuple using `stream' as input.
		require
			args_not_void: stream /= Void and tuple /= Void
			stream_readable: stream.exists and then stream.readable
		deferred
		end

end -- class VALUE_SETTER
