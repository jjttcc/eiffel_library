indexing
	description: "Abstraction for holding session-specific data"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class SESSION inherit

feature -- Access

	login_date: DATE_TIME is
			-- Date and time the session began
		deferred
		end

	logoff_date: DATE_TIME is
			-- Date and time the session ended
		deferred
		end

feature -- Status report

	logged_in: BOOLEAN is
			-- Is the session still in progress?
		do
			Result := logoff_date = Void
		ensure
			definition: Result = (logoff_date = Void)
		end

end -- class SESSION
