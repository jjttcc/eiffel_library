indexing
	description: "Utility services related to dates and times"
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class

	DATE_TIME_SERVICES

feature -- Access

	date_from_number (value: integer): DATE is
			-- Date produced from `value', which must be in the form
			-- yyyymmdd.  If `value' specifies an invalid date, the
			-- result will be Void.
		local
			y, m, d: INTEGER
		do
			!!Result.make_now
			y := value // 10000
			m := value \\ 10000 // 100
			d := value \\ 100
			if
				value < 10000 or
				y < 0 or m < 1 or m > Result.months_in_year or
				d < 1 or d > Result.days_in_i_th_month (m, y)
			then
				Result := Void
			else
				Result.make (y, m, d)
			end
		end

	date_from_string (d, separator: STRING): DATE is
			-- Date from `d' in the form yyyyXmmXdd, where X is the
			-- value of `separator' - for example, "/" when `d' is in
			-- the format yyyy/mm/dd.  If the format of `d' is invalid,
			-- the result will be Void.
		local
			sutil: STRING_UTILITIES
			components: ARRAY [STRING]
		do
			!!sutil.make (d)
			components := sutil.tokens (separator)
			if
				components.count = 3 and components.item(1).is_integer and
						components.item(2).is_integer and
						components.item(3).is_integer
			then
				!!Result.make (components.item(1).to_integer,
								components.item(2).to_integer, 
								components.item(3).to_integer)
			end
		end

	time_from_string (value: STRING): TIME is
			-- Time produced from `value', which must be in the form
			-- hh:mm:ss.nnn.  If `value' specifies an invalid time, the
			-- result will be Void.
		do
			!!Result.make_now
			if
				not Result.time_valid (value, Result.time_default_format_string)
			then
				Result := Void
			else
				Result.make_from_string_default (value)
			end
		end

	current_date: DATE is
		do
			!!Result.make_now
		end

	current_time: TIME is
		do
			!!Result.make_now
		end

feature -- Status report

	hour_valid (h: INTEGER): BOOLEAN is
			-- Is `h' a valid hour?
		do
			Result := h >= 0 and h < work_time.hours_in_day
		end

	minute_valid (m: INTEGER): BOOLEAN is
			-- Is `m' a valid minute?
		do
			Result := m >= 0 and m < work_time.minutes_in_hour
		end

	second_valid (s: INTEGER): BOOLEAN is
			-- Is `s' a valid second?
		do
			Result := s >= 0 and s < work_time.seconds_in_minute
		end

feature  {NONE} -- Implementation

	work_time: TIME is
		once
			create Result.make (0, 0, 0)
		end

end -- class DATE_TIME_SERVICES
