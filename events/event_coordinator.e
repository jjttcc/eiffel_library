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

	event_generators: LINEAR [MARKET_ANALYZER]
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
		do
			from
				event_generators.start
			until
				event_generators.exhausted
			loop
				event_generators.item.set_innermost_function (t)
				event_generators.item.execute
				event_queue.append (event_generators.item.product)
				event_generators.forth
			end
		end

end -- class EVENT_COORDINATOR
