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

	name: STRING
			-- Name of the event

	time_stamp: DATE_TIME
			-- Date and time that the event occurred

end -- class EVENT
