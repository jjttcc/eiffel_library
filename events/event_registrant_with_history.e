indexing
	description:
		"An event registrant that keeps a record of past events received %
		%and that keeps track of what types of events it is interested in"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class X_EVENT_REGISTRANT ihnerit

	EVENT_REGISTRANT

feature -- Status report

	is_interested_in (e: TYPED_EVENT): BOOLEAN is
			-- Is this registrant interested in `e'?
		do
			Result := not event_history.has (e) and event_types.has (e.type)
		end

feature {NONE} -- Implementation

	event_history: LINKED_LIST [TYPED_EVENT]
			-- All events received in the past

	event_types: LINKED_LIST [EVENT_TYPE]
			-- Types of events that this registrant is interested in

end -- class X_EVENT_REGISTRANT
