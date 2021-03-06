note

	description:
		"POLL_COMMANDs whose `active_medium' (output_device) is the console";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class CONSOLE_READER

inherit

	POLL_COMMAND
		rename
			active_medium as output_device
		redefine
			output_device
		end

feature {NONE} -- Initialization

	initialize
		do
			input_device := io.input
			output_device := io.output
		ensure
			set: input_device = io.input and output_device = io.output
		end

feature -- Access

	input_device: PLAIN_TEXT_FILE
			-- Input console

	output_device: PLAIN_TEXT_FILE
			-- Output console

feature {NONE} -- Implementation - Hook routines

	welcome_message: STRING
			-- Welcome message to display to the user on startup
		deferred
		end

feature {NONE} -- Utilities

	output_welcome_message
			-- Output a welcome message on the console.
		do
			output_device.put_string (
				welcome_message + Hit_enter_msg)
		end

feature {NONE} -- Constants

	Hit_enter_msg: STRING = " (Hit <Enter> to continue)%N"

end
