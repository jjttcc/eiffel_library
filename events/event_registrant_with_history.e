indexing
	description:
		"An event registrant that keeps a record of past events received %
		%and that keeps track of what types of events it is interested in"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class EVENT_REGISTRANT_WITH_HISTORY inherit

	EVENT_REGISTRANT

feature {NONE} -- Initialization

	make is
		do
			create {LINKED_SET [EVENT_TYPE]} event_types.make
			create event_history.make (0)
		ensure
			not_void: event_types /= Void
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
			event_history.extend (e, e.unique_id)
		end

	load_history is
			-- Load the `event_history' from persistent store.
		deferred
		ensure
			eh_not_void: event_history /= Void
		end

feature {NONE} -- Implementation

	event_history: HASH_TABLE [TYPED_EVENT, STRING]
			-- All events received in the past

invariant

	lists_not_void: event_history /= Void and event_types /= Void

end -- class EVENT_REGISTRANT_WITH_HISTORY
