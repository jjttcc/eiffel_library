indexing
	description: "Abstraction for holding session-specific data"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class SESSION inherit

feature -- Access

	login_date: DATE_TIME
			-- Date and time the session began

	logoff_date: DATE_TIME
			-- Date and time the session ended

end -- class SESSION
