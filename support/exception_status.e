indexing
	description: "Extra exception status information (in addition to %
		%what is available in class EXCEPTIONS)";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class EXCEPTION_STATUS

creation

	make

feature {NONE} -- Initialization

	make is
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

	set_fatal (arg: BOOLEAN) is
			-- Set fatal to `arg'.
		do
			fatal := arg
		ensure
			fatal_set: fatal = arg
		end

	set_description (arg: STRING) is
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
