indexing
	description: "Facilities for timing execution";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	TIMER

creation

	make

feature

	make is
			-- Initialize and start the timer.
		do
			create start_time.make_now
		end

feature -- Access

	start_time: DATE_TIME
			-- Time when `start' was called

	current_time: DATE_TIME is
			-- The current time
		do
			create Result.make_now
		end

	elapsed_time: DATE_TIME_DURATION is
			-- Amount of time that has elapsed since `start' was called.
		do
			Result := current_time.duration - start_time.duration
		end

feature -- Basic operations

	start is
			-- Start the timer.
		do
			start_time.make_now
		end

end -- class TIMER
