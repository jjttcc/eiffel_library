indexing
	description:
		"Objects that generate a list of events, based on specified %
		%conditions"
	NOTE: "!!!Consider getting rid of this class and putting its product %
	%redefinition into FUNCTION_ANALYZER."
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class EVENT_GENERATOR inherit

	FACTORY

	GLOBAL_SERVICES
		export {NONE}
			all
		end

feature -- Access

	product: CHAIN [MARKET_EVENT]

	event_type: EVENT_TYPE
			-- The type of the generated events

feature {NONE} -- Implementation

	set_event_type (name: STRING) is
			-- Create an event type with name `name', add it to the global
			-- event table, and set attribute event_type to it.
		do
			create_event_type (name)
			event_type := last_event_type
		ensure
			event_type /= Void
		end

invariant

	event_type_not_void: event_type /= Void

end -- class EVENT_GENERATOR
