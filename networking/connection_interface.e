indexing
	description: "Interface for a client connection"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class CONNECTION_INTERFACE inherit

feature -- Basic operations

	execute is
			-- Initiate the conversation with the client.
		deferred
		end

end
