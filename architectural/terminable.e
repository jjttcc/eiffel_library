indexing
	description: "Interface for cleanup notification before termination"
	status: "Copyright 1998, 1999: Jim Cochrane - see file forum.txt"
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
