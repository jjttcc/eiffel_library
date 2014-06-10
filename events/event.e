note
	description:
		"An event that occurs in the system that requires some action or set %
		%of actions to be taken"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class EVENT inherit

	COMPARABLE

feature -- Access

	name: STRING
			-- Name of the event

	description: STRING
			-- Description of the event
		deferred
		end

	time_stamp: DATE_TIME
			-- Date and time that the event occurred
		deferred
		end

	date: DATE
			-- Date to use for reporting
		deferred
		end

	time: TIME
			-- Time to use for reporting
		deferred
		end

	unique_id: STRING
			-- String that uniquely identifies the current instance
		deferred
		end

feature -- Comparison

	infix "<" (other: EVENT): BOOLEAN
		do
			if date = Void or other.date = Void then
				Result := date = Void and other.date /= Void
			elseif date.is_equal (other.date) then
				if time = Void or other.time = Void then
					Result := time = Void and other.time /= Void
				elseif time.is_equal (other.time) then
					Result := time_stamp < other.time_stamp
				else
					Result := time < other.time
				end
			else
				Result := date < other.date
			end
		end

invariant

	name_time_not_void: name /= Void and time_stamp /= Void

end -- class EVENT
