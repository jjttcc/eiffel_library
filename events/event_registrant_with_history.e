indexing
	description:
		"An event registrant that keeps a record of past events received %
		%and that keeps track of what types of events it is interested in"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class EVENT_REGISTRANT_WITH_HISTORY inherit

	EVENT_REGISTRANT
		redefine
			end_notification
		end

feature {NONE} -- Initialization

	make is
		do
			!LINKED_SET [EVENT_TYPE]!event_types.make
			!!event_cache.make
			!!event_history.make (0)
		ensure
			not_void: event_types /= Void and event_cache /= Void
		end


feature -- Access

	event_types: CHAIN [EVENT_TYPE]
			-- Types of events that this registrant is interested in

feature -- Status report

	is_interested_in (e: TYPED_EVENT): BOOLEAN is
			-- Is this registrant interested in `e'?
		do
			Result := event_types.has (e.type) and then
						not event_history.has (e.unique_id)
		end

feature -- Element change

	add_event_type (arg: EVENT_TYPE) is
			-- Add `arg' to `event_types'.
		require
			arg_not_void: arg /= Void
		do
			event_types.extend (arg)
		ensure
			event_type_added: event_types.has (arg)
		end

	remove_event_type (arg: EVENT_TYPE) is
			-- Remove `arg' from `event_types'.
		require
			arg_not_void: arg /= Void
		do
			event_types.prune (arg)
		ensure
			event_type_removed: not event_types.has (arg)
		end

feature -- Basic operations

	notify (e: TYPED_EVENT) is
		do
			event_cache.extend (e)
			event_history.extend (e, e.unique_id)
		end

	end_notification is
		do
			if not event_cache.empty then
				perform_notify (event_cache)
				event_cache.wipe_out
			end
		end

	load_history is
			-- Load the `event_history' from persistent store.
		deferred
		ensure
			eh_not_void: event_history /= Void
		end

feature {NONE} -- Hook routines

	perform_notify (elist: LIST [TYPED_EVENT]) is
			-- Notify the registrant of all events in `elist'.
		deferred
		end

feature {NONE} -- Implementation

	event_history: HASH_TABLE [TYPED_EVENT, STRING]
			-- All events received in the past

	event_cache: LINKED_LIST [TYPED_EVENT]
			-- Cache of events not yet dealt with

invariant

	lists_not_void: event_history /= Void and event_types /= Void

end -- class EVENT_REGISTRANT_WITH_HISTORY
