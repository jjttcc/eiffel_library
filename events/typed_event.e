indexing
	description:
		"An event that has an explicit type"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class TYPED_EVENT inherit

	EVENT

feature -- Access

	type: EVENT_TYPE
			-- The type of the event

end -- class TYPED_EVENT
