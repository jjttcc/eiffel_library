indexing
	description: "Utility services for use of TIMERs"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	TIMING_SERVICES

feature -- Access

	timer: TIMER

	timing_information: STRING is
		once
			Result := ""
		end

feature -- Status report

	timing_on: BOOLEAN is
			-- Is timing being performed?
		deferred
		end

feature -- Basic operations

	start_timer is
			-- If `timing_on', start the timer; otherwise do nothing.
		do
			if timing_on then
				if timer = Void then create timer.make end
				timer.start
			end
		end

	report_timing is
			-- If `timing_on', print `timing_information' and then reset it
			-- to empty.
		do
			if timing_on then
				print (timing_information)
				timing_information.wipe_out
			end
		end

	add_timing_data (msg: STRING) is
			-- If `timing_on', add `msg' to `timing_information'.
		do
			if timing_on then
				timing_information.append ("Time taken for " + msg + ":%N" +
					timer.elapsed_time.time.fine_seconds_count.out + "%N")
			end
		end

end
