note
	description: "Error subsciber that prints its error notifications to %
		%standard error (stderr)"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class STANDARD_ERROR_REPORTER inherit

	ERROR_SUBSCRIBER

feature -- Basic operations

	notify (s: STRING)
			-- Publish error message `s'.
		do
			io.error.put_string (s)
		end

end
