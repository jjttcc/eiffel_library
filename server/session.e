note
	description: "Abstraction for holding session-specific data"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class SESSION inherit

feature -- Access

	login_date: DATE_TIME
			-- Date and time the session began
		deferred
		end

	logoff_date: DATE_TIME
			-- Date and time the session ended
		deferred
		end

feature -- Status report

	logged_in: BOOLEAN
			-- Is the session still in progress?
		do
			Result := logoff_date = Void
		ensure
			definition: Result = (logoff_date = Void)
		end

end -- class SESSION
