note
	description: "Interface for a client connection"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class CONNECTION_INTERFACE inherit

feature -- Status report

	logged_out: BOOLEAN
			-- Is the last client request a "logout" request?
		deferred
		end

feature -- Basic operations

	execute
			-- Initiate the conversation with the client.
		deferred
		end

end
