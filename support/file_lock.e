note
	description: "File locking interface";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class FILE_LOCK

feature {NONE} -- Initialization

	make (fpath: STRING)
			-- Create lock to be associated with file with path `fpath'.
		require
			path_not_void: fpath /= Void
		do
			file_path := fpath
		ensure
			path_set: file_path = fpath
		end

feature -- Access

	file_path: STRING
			-- Path/filename of file to be locked

	last_error: STRING
			-- Description of last error that occurred
		deferred
		end

feature -- Status report

	locked: BOOLEAN
			-- Is the file with `file_path' locked for the current client?

	error_occurred: BOOLEAN
			-- Did an error occur during the last oepration?

feature -- Basic operations

	try_lock
			-- Attempt to lock `file'.  `locked' will be True if
			-- the attempt succeeds; otherwise it will be False.
		require
			not_locked: not locked
		deferred
		end

	lock
			-- Lock the file, blocking if it is already locked.
		require
			not_locked: not locked
		deferred
		ensure
			locked: locked
		end

	unlock
			-- Unlock the file.
		require
			locked: locked
		deferred
		ensure
			not_locked: not locked
		end

end -- class FILE_LOCK
