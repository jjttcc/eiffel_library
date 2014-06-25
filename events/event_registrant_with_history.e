note
	description:
		"An event registrant that keeps a record of past events received %
		%and that keeps track of what types of events it is interested in"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class EVENT_REGISTRANT_WITH_HISTORY inherit

	EVENT_REGISTRANT

feature {NONE} -- Initialization

	make
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

	is_interested_in (e: TYPED_EVENT): BOOLEAN
			-- Is this registrant interested in `e'?
		do
			Result := event_types.has (e.type) and then
						not event_history.has (e.unique_id)
		end

feature -- Element change

	add_event_type (arg: EVENT_TYPE)
			-- Add `arg' to `event_types'.
		require
			arg_not_void: arg /= Void
		do
			event_types.extend (arg)
		ensure
			event_type_added: event_types.has (arg)
		end

	remove_event_type (arg: EVENT_TYPE)
			-- Remove `arg' from `event_types'.
		require
			arg_not_void: arg /= Void
		do
			event_types.prune (arg)
		ensure
			event_type_removed: not event_types.has (arg)
		end

feature -- Basic operations

	notify (e: TYPED_EVENT)
		do
			event_history.extend (e, e.unique_id)
		end

	load_history
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
