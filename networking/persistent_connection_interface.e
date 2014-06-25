note
	description: "Interface for a %"persistent%" connection"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class PERSISTENT_CONNECTION_INTERFACE inherit

	CONNECTION_INTERFACE

feature -- Access

	input_device: IO_MEDIUM
			-- Input device used for persistent communication
		deferred
		end

	output_device: IO_MEDIUM
			-- Output device used for persistent communication
		deferred
		end

feature -- Status setting

	set_input_device (arg: IO_MEDIUM)
			-- Set input_device to `arg'.
		require
			arg_not_void: arg /= Void
		deferred
		ensure
			input_device_set: input_device = arg and input_device /= Void
		end

	set_output_device (arg: IO_MEDIUM)
			-- Set output_device to `arg'.
		require
			arg_not_void: arg /= Void
		deferred
		ensure
			output_device_set: output_device = arg and output_device /= Void
		end

end
