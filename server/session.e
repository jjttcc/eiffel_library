indexing
	description: "Abstraction for holding session-specific data"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
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

end -- class SESSION
