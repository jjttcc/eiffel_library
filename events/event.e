indexing
	description:
		"An event that occurs in the system that requires some action or set %
		%of actions to be taken"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class EVENT inherit

	ANY

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

invariant

	name_time_not_void: name /= Void and time_stamp /= Void

end -- class EVENT
