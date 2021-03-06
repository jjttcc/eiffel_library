note
	description:
		"An abstraction for the type of an event"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class EVENT_TYPE inherit

	ANY
		redefine
			is_equal
		end

creation

	make

feature -- Initialization

	make (nm: STRING; type_ID: INTEGER)
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

feature -- Status report

	is_equal (other: like Current): BOOLEAN
		do
			Result := other.ID = ID
		end

invariant

	name_not_void: name /= Void

end -- class EVENT_TYPE
