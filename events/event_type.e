indexing
	description:
		"An abstraction for the type of an event"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class EVENT_TYPE inherit

	ANY
		redefine
			out
		end

creation

	make

feature -- Initialization

	make (nm: STRING; type_ID: INTEGER) is
		require
			not_void: nm /= Void
		do
			name := nm
			ID := type_ID
		ensure
			name = nm and ID = type_ID
		end

feature -- Access

	ID: INTEGER
			-- Unique identifier

	name: STRING
			-- Name of the event type

	out: STRING is
		do
			Result := clone (ID.out)
			Result.extend (' ')
			Result.append (name)
		end

invariant

	name_not_void: name /= Void

end -- class EVENT_TYPE