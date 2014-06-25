note
	description: "Facilities for timing execution";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class

	TIMER

creation

	make

feature

	make
			-- Initialize and start the timer.
		do
			create start_time.make_now
		end

feature -- Access

	start_time: DATE_TIME
			-- Time when `start' was called

	current_time: DATE_TIME
			-- The current time
		do
			create Result.make_now
		end

	elapsed_time: DATE_TIME_DURATION
			-- Amount of time that has elapsed since `start' was called.
		do
			Result := current_time.duration - start_time.duration
			-- DATE_TIME_DURATION requires origin to be set.
			Result.set_origin_date_time (
				create {DATE_TIME}.make_by_date (create {DATE}.make (1, 1, 1)))
		end

feature -- Basic operations

	start
			-- Start the timer.
		do
			start_time.make_now
		end

end -- class TIMER
