indexing
	description:
		"Abstraction that registers to be notified of specific types of %
		%events and that processes each event of which it was notified"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class 

	EVENT_REGISTRANT

feature -- Access

	name: STRING is
			-- Name of the registrant
		deferred
		end

feature -- Status report

	is_interested_in (e: EVENT): BOOLEAN is
			-- Is this registrant interested in `e'?
		deferred
		end

feature -- Basic operations

	notify (e: EVENT) is
			-- Notify this registrant of event `e'.
		require
			e_wanted: is_interested_in (e)
		deferred
		end

	end_notification is
			-- In case the event notifications are being cached, send
			-- a message that the there are no more events for the
			-- current processing session.
		do
		end

end -- class EVENT_REGISTRANT
