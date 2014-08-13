note
	description: "Interface for cleanup notification before termination"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class

	CLEANABLE

feature -- Utility

	cleanup(cleaner: CLEANUP_SERVICE)
			-- Perform any needed cleanup actions before program termination.
		deferred
		end

end -- TERMINABLE
