indexing
	description: "Interface for a %"persistent%" connection"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class PERSISTENT_CONNECTION_INTERFACE inherit

	CONNECTION_INTERFACE

feature -- Access

	input_device: IO_MEDIUM is
			-- Input device used for persistent communication
		deferred
		end

	output_device: IO_MEDIUM is
			-- Output device used for persistent communication
		deferred
		end

feature -- Status setting

	set_input_device (arg: IO_MEDIUM) is
			-- Set input_device to `arg'.
		require
			arg_not_void: arg /= Void
		deferred
		ensure
			input_device_set: input_device = arg and input_device /= Void
		end

	set_output_device (arg: IO_MEDIUM) is
			-- Set output_device to `arg'.
		require
			arg_not_void: arg /= Void
		deferred
		ensure
			output_device_set: output_device = arg and output_device /= Void
		end

end
