indexing
	description: "Services for cleanup registration and execution"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class CLEANUP_SERVICES inherit

	EXCEPTIONS
		export
			{NONE} all
		end

	GENERAL_UTILITIES
		export
			{NONE} all
		end

feature -- Utility

	register_for_termination (v: TERMINABLE) is
			-- Add `v' to termination_registrants.
		require
			not_registered: not termination_registrants.has (v)
		do
			termination_registrants.extend (v)
		end

	unregister_for_termination (v: TERMINABLE) is
			-- Remove (all occurrences of) `v' from termination_registrants.
		do
			termination_registrants.prune_all (v)
		ensure
			not_registered: not termination_registrants.has (v)
		end

	termination_cleanup is
			-- Send cleanup notification to all members of
			-- `termination_registrants' in the order they were added
			-- (with `register_for_termination').
		do
			from
				termination_registrants.start
			until
				termination_registrants.exhausted
			loop
				termination_registrants.item.cleanup
				termination_registrants.forth
			end
		end

feature -- Access

	termination_registrants: LIST [TERMINABLE] is
			-- Registrants for termination cleanup notification
		once
			create {LINKED_LIST [TERMINABLE]} Result.make
		end

end -- CLEANUP_SERVICES
