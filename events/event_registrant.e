note
	description:
		"Abstraction that registers to be notified of specific types of %
		%events and that processes each event of which it was notified"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class 

	EVENT_REGISTRANT

feature -- Access

	name: STRING
			-- Name of the registrant
		deferred
		end

feature -- Status report

	is_interested_in (e: EVENT): BOOLEAN
			-- Is this registrant interested in `e'?
		deferred
		end

feature -- Basic operations

	notify (e: EVENT)
			-- Notify this registrant of event `e'.
		require
			e_wanted: is_interested_in (e)
		deferred
		end

	end_notification
			-- In case the event notifications are being cached, send
			-- a message that the there are no more events for the
			-- current processing session.
		do
		end

end -- class EVENT_REGISTRANT
