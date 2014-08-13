note
	description: "Localized services for cleanup registration and execution"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class CLEANUP_SERVICE inherit

feature -- Utility

	register_for_cleanup(c: CLEANABLE)
			-- Add `c' to cleanup_registrants.
		require
			not_registered: not cleanup_registrants.has(c)
		do
			cleanup_registrants.extend(c)
		end

	unregister_for_cleanup(c: CLEANABLE)
			-- Remove (all occurrences of) `c' from cleanup_registrants.
		do
			if unregistered_list = Void then
				create unregistered_list.make
			end
			unregistered_list.extend(c)
		ensure
			not_registered: not is_registered(c)
		end

	perform_cleanup
			-- Send cleanup notification to all members of
			-- `cleanup_registrants' in the order they were added
			-- (with `register_for_cleanup').
		do
			if
				unregistered_list /= Void and then
				not unregistered_list.is_empty
			then
				across unregistered_list as x loop
					cleanup_registrants.prune_all(x.item)
					unregistered_list.prune_all(x.item)
				end 
			end
			from
				cleanup_registrants.start
			until
				cleanup_registrants.exhausted
			loop
				cleanup_registrants.item.cleanup(Current)
				cleanup_registrants.forth
			end
		end

feature -- Access

	cleanup_registrants: LIST [CLEANABLE]
			-- Registrants for cleanup notification
		do
			if cleanup_registrants_list = Void then
				create {LINKED_LIST [CLEANABLE]} cleanup_registrants_list.make
			end
			Result := cleanup_registrants_list
		end

feature -- Status report

	is_registered(c: CLEANABLE): BOOLEAN
			-- Is `c' registered with Current for cleanup?
		do
			Result := cleanup_registrants.has(c) and then
				(unregistered_list = Void or else not unregistered_list.has(c))
		end

feature {NONE} -- Implementation

	cleanup_registrants_list: LINKED_LIST [CLEANABLE]

	unregistered_list: LINKED_LIST [CLEANABLE]
			-- Former registrants that have been unregistered

end -- CLEANUP_SERVICE
