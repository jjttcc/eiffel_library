indexing
	description:
		"An event that has an explicit type"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class TYPED_EVENT inherit

	EVENT
		redefine
			is_equal
		end

feature -- Access

	type: EVENT_TYPE
			-- The type of the event

feature -- Status report

	is_equal (other: like Current): BOOLEAN is
		do
			Result := other.type = type and
						other.time_stamp.is_equal (time_stamp)
		end

invariant

	type /= Void

end -- class TYPED_EVENT
