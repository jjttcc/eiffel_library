indexing
	description: "Publisher of error reports"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class ERROR_PUBLISHER inherit

	general_utilities
		export
			{NONE} all
		end

feature -- Access

	error_subscribers: LINKED_LIST [ERROR_SUBSCRIBER]
			-- Current subscribers to error reports

feature -- Status report

	has_error_subscribers: BOOLEAN is
			-- Are there currently one or more error-subscribers?
		do
			Result := error_subscribers /= Void and then
				not error_subscribers.is_empty
		end

feature -- Element change

	add_error_subscriber (s: ERROR_SUBSCRIBER) is
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

	remove_error_subscriber (s: ERROR_SUBSCRIBER) is
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

	publish_error (s: STRING) is
			-- Publish error message `s'.
		do
			if non_empty_string (s) and has_error_subscribers then
				current_error := s
				error_subscribers.do_all (agent notify_of_current_error)
			end
		end

feature {NONE} -- Implementation

	current_error: STRING

	notify_of_current_error (s: ERROR_SUBSCRIBER) is
		do
			s.notify (current_error)
		end

end
