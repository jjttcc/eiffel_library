indexing
	description: "Interface for cleanup notification before termination"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class

	TERMINABLE

feature -- Utility

	cleanup is
			-- Perform any needed cleanup actions before program termination.
		deferred
		end

end -- TERMINABLE
