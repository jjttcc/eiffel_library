indexing
	description:
		"Event dispatcher - accepts event registrants and dispatches events %
		%from an event queue to all registrants."
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class 

	EVENT_DISPATCHER

creation

	make

feature -- Initialization

	make (q: QUEUE [EVENT]) is
		do
			event_queue := q
			!!registrants.make
		ensure
			set: event_queue = q
		end

feature -- Access

	event_queue: QUEUE [EVENT]
			-- Queue of events to be dispatched

	registrants: LINKED_LIST [EVENT_REGISTRANT]
			-- registered recipients of events

feature -- Status setting

	set_event_queue (arg: QUEUE [EVENT]) is
			-- Set event_queue to `arg'.
		require
			arg /= Void
		do
			event_queue := arg
		ensure
			event_queue_set: event_queue = arg and event_queue /= Void
		end

feature -- Element change

	register (r: EVENT_REGISTRANT) is
			-- Register `r' for event notification.
		do
			registrants.extend (r)
		ensure
			added: registrants.has (r)
			one_more: registrants.count = old registrants.count + 1
		end

feature -- Basic operations

	execute is
			-- Dispatch all events in the `event_queue' to all registrants.
		require
			queue_set: event_queue /= Void
		local
			e: EVENT
		do
			from
			until
				finished_processing
			loop
				if not event_queue.empty then
					e := event_queue.item
					event_queue.remove
					dispatch (e)
				else
					empty_queue_action
				end
			end
		end

feature {NONE} -- Hook methods

	finished_processing: BOOLEAN is
			-- Is there no more processing to do on the event_queue?
			-- Answer: true if event_queue is empty - redefine in
			-- descendants for specialized behavior.
		do
			Result := event_queue.empty
		end

	dispatch (e: EVENT) is
			-- Dispatch event `e' to applicable registrants.
		require
			not_void: e /= Void
		do
			from
				registrants.start
			until
				registrants.exhausted
			loop
				if registrants.item.is_interested_in (e) then
					registrants.item.notify (e)
				end
				registrants.forth
			end
		end

	empty_queue_action is
			-- Action to perform when event_queue is empty.
			-- Null action by default - descendants redefine as needed.
		do
		end

invariant

	registrants /= Void

end -- class EVENT_DISPATCHER
