indexing
	description:
		"An event registrant that keeps a record of past events received %
		%and that keeps track of what types of events it is interested in"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class 

	EVENT_REGISTRANT

feature -- Status report

	is_interested_in (e: EVENT): BOOLEAN is
			-- Is this registrant interested in `e'?
		deferred
		end

feature -- Basic operations

	notify (e: EVENT) is
			-- Notify this registrant of event `e'.
		deferred
		end

end -- class EVENT_REGISTRANT
