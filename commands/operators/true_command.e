note
	description: "Command whose value is always True"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class TRUE_COMMAND inherit

	RESULT_COMMAND [BOOLEAN]

feature -- Status report

	arg_mandatory: BOOLEAN = False

feature -- Basic operations

	execute (arg: ANY)
		once
			value := True
		end

end -- class TRUE_COMMAND
