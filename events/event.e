indexing
	description:
		"An event that occurs in the system that requires some action or set %
		%of actions to be taken"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class EVENT inherit

	COMPARABLE

feature -- Access

	name: STRING
			-- Name of the event

	description: STRING is
			-- Description of the event
		deferred
		end

	time_stamp: DATE_TIME is
			-- Date and time that the event occurred
		deferred
		end

	date: DATE is
			-- Date to use for reporting
		deferred
		end

	time: TIME is
			-- Time to use for reporting
		deferred
		end

	unique_id: STRING is
			-- String that uniquely identifies the current instance
		deferred
		end

feature -- Comparison

	infix "<" (other: EVENT): BOOLEAN is
		do
			Result := time_stamp < other.time_stamp
		end

invariant

	name_time_not_void: name /= Void and time_stamp /= Void

end -- class EVENT
