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

	time_from_string (value, separator: STRING): TIME is
			-- Time produced from `value', which must be in the form
			-- hhXmm[Xss], where X denotes the character specified by
			-- `separator' and [Xss] means that the seconds component is
			-- optional.  If `value' specifies an invalid time, the
			-- result will be Void.
		require
			value_not_void: value /= Void
			separator_valid: separator /= Void and separator.count = 1
		local
			h, m, s, count: INTEGER
			tokens: LIST [STRING]
		do
			string_tool.make (value)
			tokens := string_tool.tokens (separator)
			count := tokens.count
			if count = 2 or count = 3 then
				if (tokens @ 1).is_integer and (tokens @ 2).is_integer then
					h := (tokens @ 1).to_integer
					m := (tokens @ 2).to_integer
					if count = 3 then
						if (tokens @ 3).is_integer then
							s := (tokens @ 3).to_integer
						else
							h := -1
						end
					end
					if h >= 0 then
						create Result.make (h, m, s)
					end
				end
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

	string_tool: STRING_UTILITIES is
		once
			create Result.make ("")
		end

end -- class DATE_TIME_SERVICES
