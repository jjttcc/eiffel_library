indexing
	description: "Error subsciber that prints its error notifications to %
		%standard error (stderr)"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class STANDARD_ERROR_REPORTER inherit

	ERROR_SUBSCRIBER

feature -- Basic operations

	notify (s: STRING) is
			-- Publish error message `s'.
		do
			io.error.put_string (s)
		end

end
