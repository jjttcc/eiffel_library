indexing
	description:
		"An event that has an explicit type"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class TYPED_EVENT inherit

	EVENT
		redefine
			is_equal
		end

feature -- Access

	type: EVENT_TYPE
			-- The type of the event

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
		do
			Result := other.type = type and
						other.time_stamp.is_equal (time_stamp)
		end

invariant

	type /= Void

end -- class TYPED_EVENT
