indexing
	description:
		"An event registrant that keeps a record of past events received %
		%and that keeps track of what types of events it is interested in"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class EVENT_REGISTRANT_WITH_HISTORY inherit

	EVENT_REGISTRANT

feature -- Initialization

	make is
		do
			!!event_history.make
			event_history.object_comparison
			!!event_types.make
		end

feature -- Status report

	is_interested_in (e: TYPED_EVENT): BOOLEAN is
			-- Is this registrant interested in `e'?
		do
			Result := not event_history.has (e) and event_types.has (e.type)
		end

feature -- Access

	event_types: LINKED_LIST [EVENT_TYPE]
			-- Types of events that this registrant is interested in

feature -- Element change

	add_event_type (arg: EVENT_TYPE) is
			-- Add `arg' to `event_types'.
		require
			arg_not_void: arg /= Void
		do
			event_types.extend (arg)
		ensure
			event_type_added: event_types.count = old event_types.count + 1 and
				event_types.has (arg)
		end

feature -- Basic operations

	notify (e: TYPED_EVENT) is
		do
			perform_notify (e)
			event_history.extend (e)
		end

feature {NONE} -- Hook routines

	perform_notify (e: TYPED_EVENT) is
		deferred
		end

feature {NONE} -- Implementation

	event_history: LINKED_LIST [TYPED_EVENT]
			-- All events received in the past

invariant

	lists_not_void: event_history /= Void and event_types /= Void

end -- class EVENT_REGISTRANT_WITH_HISTORY
