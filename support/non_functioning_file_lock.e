indexing
	description: "A non-functioning file locking implementation that always %
		%succeeds in locking and unlocking the target file without actually %
		%performing any action - intended for platforms where true file %
		%locking has not yet been implemented"
	note: "It is a good idea to document, for the platform this %
		%implementation is being used on, any consequences of using this %
		%implementation, such as, for example, safe editing not being %
		%guaranteed for two processes running the same code that share %
		%and allow editing the same file"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class NON_FUNCTIONING_FILE_LOCK inherit

	FILE_LOCK

creation

	make

feature -- Access

	last_error: STRING is ""

feature -- Basic operations

	try_lock is
			-- Always succeeds.
		do
			locked := True
		end

	lock is
			-- Always succeeds without blocking.
		do
			locked := True
		end

	unlock is
		do
			locked := False
		end

end -- class NON_FUNCTIONING_FILE_LOCK
