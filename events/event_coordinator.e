indexing
	description:
		"An event coordinator that uses event generators to generate events %
		%and passes a queue of the generated events to a dispatcher"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class

	EVENT_COORDINATOR

feature -- Access

	event_generators: LINEAR [LINEAR [MARKET_ANALYZER]]
			-- Generators of events to be dispatched

	market_list: LINEAR [TRADABLE]

feature -- Basic operations

	execute is
		local
			dispatcher: EVENT_DISPATCHER
		do
			from
				market_list.start
			until
				market_list.exhausted
			loop
				process (market_list.item)
				market_list.forth
			end
			!!dispatcher.make (event_queue)
			dispatcher.execute
		end

feature {NONE} -- Implementation

	event_queue: QUEUE [EVENT]

	process (t: TRADABLE) is
		local
			dispatcher: EVENT_DISPATCHER
		do
			from
				event_generators.start
			until
				event_generators.exhausted
			loop
				x (t, event_generators.item)
			end
		end

	x (t: TRADABLE; eg_list: LINEAR [MARKET_ANALYZER]) is
		local
			dispatcher: EVENT_DISPATCHER
			l: LINKED_LIST [LINKED_LIST [EVENT]]
		do
			from
				eg_list.start
			until
				eg_list.exhausted
			loop
				eg_list.item.set_innermost_function (t)
				eg_list.item.execute
				l.extend (eg_list.item.product)
				eg_list.forth
			end
			if not l.empty then
				event_queue.append (combine_events (l))
			end
		end

	combine_events (l: LINEAR [LINEAR [EVENT]]): LINEAR [EVENT] is
			-- Combine each event list in l such that their date/times
			-- something-or-other ....
		require
			l_not_empty: not l.empty
		do
			if l.count = 1 then --!!!!!!!!!!!!!!!!!check
				Result := l.item
			else
				--something-or-other
			end
		end

end -- class EVENT_COORDINATOR
