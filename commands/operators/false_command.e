note
	description: "Command whose value is always False"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class FALSE_COMMAND inherit

	RESULT_COMMAND [BOOLEAN]

feature -- Status report

	arg_mandatory: BOOLEAN = False

feature -- Basic operations

	execute (arg: ANY)
		once
			value := False
		end

end -- class FALSE_COMMAND
