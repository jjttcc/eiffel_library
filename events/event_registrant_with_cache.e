note
	description:
		"An event registrant that keeps a record of past events received %
		%and that keeps track of what types of events it is interested in"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class EVENT_REGISTRANT_WITH_CACHE inherit

	EVENT_REGISTRANT
		redefine
			end_notification
		end

feature {NONE} -- Initialization

	make
		do
			create event_cache.make
		ensure
			not_void: event_cache /= Void
		end

feature -- Status report

	is_interested_in (e: EVENT): BOOLEAN
			-- Is this registrant interested in `e'?  (Yes)
		once
			Result := True
		end

feature -- Basic operations

	notify (e: TYPED_EVENT)
		do
			event_cache.extend (e)
		end

	end_notification
		do
			if not event_cache.is_empty then
				perform_notify
				event_cache.wipe_out
			end
		end

feature {NONE} -- Hook routines

	perform_notify
			-- Notify the registrant that event processing has completed
			-- and `event_cache' holds the resulting new events.
		require
			cache_not_empty: event_cache /= Void and not event_cache.is_empty
		deferred
		end

feature {NONE} -- Implementation

	event_cache: LINKED_LIST [TYPED_EVENT]
			-- Cache of events not yet dealt with

invariant

	cache_exists: event_cache /= Void

end -- class EVENT_REGISTRANT_WITH_CACHE
