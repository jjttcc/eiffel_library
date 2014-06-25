note
	description:
		"An event that has an explicit type"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class TYPED_EVENT inherit

	EVENT
		redefine
			is_equal
		end

feature -- Access

	type: EVENT_TYPE
			-- The type of the event

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := other.type = type and
						other.time_stamp.is_equal (time_stamp)
		end

invariant

	type /= Void

end -- class TYPED_EVENT
