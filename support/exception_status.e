note
	description: "Extra exception status information (in addition to %
		%what is available in class EXCEPTIONS)";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class EXCEPTION_STATUS

creation

	make

feature {NONE} -- Initialization

	make
		do
			create description.make (0)
		end

feature -- Access

	description: STRING
			-- Description of the cause of the exception

feature -- Status report

	fatal: BOOLEAN
			-- Is the error condition that caused the exception considered
			-- fatal?

feature -- Status setting

	set_fatal (arg: BOOLEAN)
			-- Set fatal to `arg'.
		do
			fatal := arg
		ensure
			fatal_set: fatal = arg
		end

	set_description (arg: STRING)
			-- Set description to `arg'.
		require
			arg_not_void: arg /= Void
		do
			description := arg
		ensure
			description_set: description = arg and description /= Void
		end

invariant

	description_not_void: description /= Void

end -- class EXCEPTION_STATUS
