indexing
	description:
		"An event that has an explicit type"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class TYPED_EVENT inherit

	EVENT
		export {ANY}
			set_description
		redefine
			out, is_equal
		end

creation

	make

feature -- Initialization

	make (nm: STRING; time: DATE_TIME; e_type: EVENT_TYPE) is
		require
			not_void: nm /= Void and time /= Void and e_type /= Void
		do
			name := nm
			time_stamp := time
			type := e_type
		ensure
			set: name = nm and time_stamp = time and type = e_type
		end

feature -- Access

	type: EVENT_TYPE
			-- The type of the event

	out: STRING is
		do
			Result := Precursor
			Result.extend (' ')
			Result.append (type.out)
		end

feature -- Status report

	is_equal (other: like Current): BOOLEAN is
		do
			Result := other.type = type and
						other.time_stamp.is_equal (time_stamp)
		end

invariant

	type /= Void

end -- class TYPED_EVENT