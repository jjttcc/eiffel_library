indexing
	description: "Interface for cleanup notification before termination"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	TERMINABLE

feature -- Utility

	cleanup is
			-- Perform any needed cleanup actions before program termination.
		deferred
		end

end -- TERMINABLE
