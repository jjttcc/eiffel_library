note
	description: "Subscriber to error reports"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class

	ERROR_SUBSCRIBER

feature {ERROR_PUBLISHER} -- Basic operations

	notify (s: STRING)
			-- Notify Current of error message `s'.
		require
			s_valid: s /= Void and then not s.is_empty
		deferred
		end

end
