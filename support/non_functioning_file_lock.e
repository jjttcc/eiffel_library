note
	description: "A non-functioning file locking implementation that always %
		%succeeds in locking and unlocking the target file without actually %
		%performing any action - intended for platforms where true file %
		%locking has not yet been implemented"
	note1: "It is a good idea to document, for the platform this %
		%implementation is being used on, any consequences of using this %
		%implementation, such as, for example, safe editing not being %
		%guaranteed for two processes running the same code that share %
		%and allow editing the same file"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class NON_FUNCTIONING_FILE_LOCK inherit

	FILE_LOCK

creation

	make

feature -- Access

	last_error: STRING = ""

feature -- Basic operations

	try_lock
			-- Always succeeds.
		do
			locked := True
		end

	lock
			-- Always succeeds without blocking.
		do
			locked := True
		end

	unlock
		do
			locked := False
		end

end -- class NON_FUNCTIONING_FILE_LOCK
