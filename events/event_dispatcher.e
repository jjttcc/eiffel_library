note
	description:
		"Event dispatcher - accepts event registrants and dispatches events %
		%from an event queue to all registrants."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class 

	EVENT_DISPATCHER

creation

	make

feature -- Initialization

	make
		do
			create registrants.make
		end

feature -- Access

	event_queue: QUEUE [EVENT]
			-- Queue of events to be dispatched

	registrants: LINKED_LIST [EVENT_REGISTRANT]
			-- registered recipients of events

feature -- Status setting

	set_event_queue (arg: QUEUE [EVENT])
			-- Set event_queue to `arg'.
		require
			arg /= Void
		do
			event_queue := arg
		ensure
			event_queue_set: event_queue = arg and event_queue /= Void
		end

feature -- Element change

	register (r: EVENT_REGISTRANT)
			-- Register `r' for event notification.
		do
			registrants.extend (r)
		ensure
			added: registrants.has (r)
			one_more: registrants.count = old registrants.count + 1
		end

feature -- Basic operations

	execute
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
				if not event_queue.is_empty then
					e := event_queue.item
					event_queue.remove
					dispatch (e)
				else
					empty_queue_action
				end
			end
			cleanup
		end

feature {NONE} -- Hook methods

	finished_processing: BOOLEAN
			-- Is there no more processing to do on the event_queue?
			-- Answer: True if event_queue is empty - redefine in
			-- descendants for specialized behavior.
		do
			Result := event_queue.is_empty
		end

	dispatch (e: EVENT)
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

	cleanup
			-- Perform any needed cleanup operations.
			-- Default: Send end_notification messages to all registrants
		do
			from
				registrants.start
			until
				registrants.exhausted
			loop
				registrants.item.end_notification
				registrants.forth
			end
		end

	empty_queue_action
			-- Action to perform when event_queue is empty.
			-- Null action by default - descendants redefine as needed.
		do
		end

invariant

	registrants /= Void

end -- class EVENT_DISPATCHER
