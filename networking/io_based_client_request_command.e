indexing
	description: "CLIENT_REQUEST_COMMANDs that use an IO_MEDIUM to respond %
		%to the client request"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class IO_BASED_CLIENT_REQUEST_COMMAND inherit

	CLIENT_REQUEST_COMMAND

feature -- Access

	output_medium: IO_MEDIUM
			-- Medium for output

feature -- Element change

	set_output_medium (arg: IO_MEDIUM) is
			-- Set output_medium to `arg'.
		require
			arg_not_void: arg /= Void
		do
			output_medium := arg
		ensure
			output_medium_set: output_medium = arg and output_medium /= Void
		end

end
