note
	description: "Publisher of error reports"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class ERROR_PUBLISHER inherit

	general_utilities
		export
			{NONE} all
			{ANY} deep_twin, is_deep_equal, standard_is_equal
		end

feature -- Access

	error_subscribers: LINKED_LIST [ERROR_SUBSCRIBER]
			-- Current subscribers to error reports

feature -- Status report

	has_error_subscribers: BOOLEAN
			-- Are there currently one or more error-subscribers?
		do
			Result := error_subscribers /= Void and then
				not error_subscribers.is_empty
		end

feature -- Element change

	add_error_subscriber (s: ERROR_SUBSCRIBER)
			-- Add error-subscriber `s'.
		require
			s_exists: s /= Void
		do
			if error_subscribers = Void then
				create error_subscribers.make
			end
			error_subscribers.extend (s)
		ensure
			s_added: error_subscribers.has (s)
		end

	remove_error_subscriber (s: ERROR_SUBSCRIBER)
			-- Remove subscriber `s' (reference comparison).
		require
			s_exists: s /= Void
		do
			if error_subscribers /= Void then
				error_subscribers.prune_all (s)
			end
		ensure
			s_removed: not error_subscribers.has (s)
		end

feature {NONE} -- Basic operations

	publish_error (s: STRING)
			-- Publish error message `s'.
		do
			if non_empty_string (s) and has_error_subscribers then
				error_subscribers.do_all (
					agent notify_of_current_error (?, s))
			end
		end

feature {NONE} -- Implementation

	notify_of_current_error (subs: ERROR_SUBSCRIBER; msg: STRING)
		do
			subs.notify (msg)
		end

end
