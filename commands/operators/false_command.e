indexing
	description: "Command whose value is always False"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class FALSE_COMMAND inherit

	RESULT_COMMAND [BOOLEAN]

feature -- Status report

	arg_mandatory: BOOLEAN is False

feature -- Basic operations

	execute (arg: ANY) is
		once
			value := False
		end

end -- class FALSE_COMMAND
