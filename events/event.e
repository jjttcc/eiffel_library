indexing
	description:
		"An event that occurs in the system that requires some action or set %
		%of actions to be taken"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class

	EVENT

feature -- Access

	ID: INTEGER
			-- Unique identifier of the event
			--!!!Is this ID needed?  Or can it be ID'd from the
			--!!!time stamp or time stamp and name?

	name: STRING
			-- Name of the event

	description: STRING
			-- Description of the event

	time_stamp: DATE_TIME
			-- Date and time that the event occurred

feature {NONE}

	set_description (arg: STRING) is
			-- Set description to `arg'.
		require
			arg /= Void
		do
			description := arg
		ensure
			description_set: description = arg and description /= Void
		end

invariant

	name_time_not_void: name /= Void and time_stamp /= Void

end -- class EVENT
