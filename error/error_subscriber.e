indexing
	description: "Subscriber to error reports"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	ERROR_SUBSCRIBER

feature {ERROR_PUBLISHER} -- Basic operations

	notify (s: STRING) is
			-- Notify Current of error message `s'.
		require
			s_valid: s /= Void and then not s.is_empty
		deferred
		end

end
