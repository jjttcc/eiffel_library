indexing
	description: "Utility services related to dates and times"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

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
			create Result.make_now
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
				create Result.make (y, m, d)
			end
		end

	date_from_string (d, separator: STRING): DATE is
			-- Date from `d' in the form yyyyXmmXdd, where X is the
			-- value of `separator' - for example, "/" when `d' is in
			-- the format yyyy/mm/dd.  If the format of `d' is invalid,
			-- the result will be Void.
		local
			components: ARRAY [STRING]
		do
			string_tool.set_target (d)
			components := string_tool.tokens (separator)
			if
				components.count = 3 and components.item(1).is_integer and
						components.item(2).is_integer and
						components.item(3).is_integer
			then
				create Result.make (components.item(1).to_integer,
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
			string_tool.set_target (value)
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
					if
						h >= 0 and work_time.is_correct_time (h, m, s, False)
					then
						create Result.make (h, m, s)
					end
				end
			end
		end

	month_from_3_letter_abbreviation (m: STRING): INTEGER is
			-- Month as an integer from the 3-letter abbreviation specified
			-- by `m'
		require
			valid_month: m /= Void and m.count = 3 and
				month_table.has (m)
		do
			Result := month_table @ m
		ensure
			valid_result: Result >= 1 and Result <= 12
			definition: Result = month_table @ m
		end

	day_of_week_from_3_letter_abbreviation (d: STRING): INTEGER is
			-- Weekday as an integer from the 3-letter abbreviation specified
			-- by `d', where 1 is Sunday .. 7 is Saturday
		require
			valid_day_of_week: d /= Void and d.count = 3 and
				day_of_week_table.has (d)
		do
			Result := day_of_week_table @ d
		ensure
			valid_result: Result >= 1 and Result <= 7
			definition: Result = day_of_week_table @ d
		end

	current_date: DATE is
		do
			create Result.make_now
		end

	current_time: TIME is
		do
			create Result.make_now
		end

	date_as_yyyymmdd (date: DATE): STRING is
			-- `date' formatted as yyyymmdd
		do
			Result := formatted_date (date, 'y', 'm', 'd', "")
		end

	formatted_date (date: DATE; f1, f2, f3: CHARACTER; fs: STRING): STRING is
			-- Formatted `date', with year, month, and day in the order
			-- specified by `f1', `f2', and `f3', separated by `fs'.  If
			-- `fs' is empty, no field separator is used.
		require
			fields_y_m_or_d:
				(f1 = 'y' or f1 = 'm' or f1 = 'd') and
				(f2 = 'y' or f2 = 'm' or f2 = 'd') and
				(f3 = 'y' or f3 = 'm' or f3 = 'd')
			fields_unique: f1 /= f2 and f2 /= f3 and f3 /= f1
			not_void: date /= Void and fs /= Void
		local
			fmtr: FORMAT_INTEGER
			i1, i2, i3: INTEGER
		do
			create fmtr.make (2)
			fmtr.set_fill ('0')
			if f1 = 'y' then
				i1 := date.year
			elseif f1 = 'm' then
				i1 := date.month
			else
				check f1 = 'd' end
				i1 := date.day
			end
			if f2 = 'y' then
				i2 := date.year
			elseif f2 = 'm' then
				i2 := date.month
			else
				check f2 = 'd' end
				i2 := date.day
			end
			if f3 = 'y' then
				i3 := date.year
			elseif f3 = 'm' then
				i3 := date.month
			else
				check f3 = 'd' end
				i3 := date.day
			end
			Result := fmtr.formatted (i1)
			Result.append (fs)
			Result.append (fmtr.formatted (i2))
			Result.append (fs)
			Result.append (fmtr.formatted (i3))
		end

	formatted_time (time: TIME; f1, f2, f3: CHARACTER; fs: STRING): STRING is
			-- Formatted `time', with hour, minute, and second in the order
			-- specified by `f1', `f2', and `f3', separated by `fs'.  If
			-- `fs' is empty, no field separator is used.
		require
			fields_y_m_or_d:
				(f1 = 'h' or f1 = 'm' or f1 = 's') and
				(f2 = 'h' or f2 = 'm' or f2 = 's') and
				(f3 = 'h' or f3 = 'm' or f3 = 's')
			fields_unique: f1 /= f2 and f2 /= f3 and f3 /= f1
			not_void: time /= Void and fs /= Void
		local
			fmtr: FORMAT_INTEGER
			i1, i2, i3: INTEGER
		do
			create fmtr.make (2)
			fmtr.set_fill ('0')
			if f1 = 'h' then
				i1 := time.hour
			elseif f1 = 'm' then
				i1 := time.minute
			else
				check f1 = 's' end
				i1 := time.second
			end
			if f2 = 'h' then
				i2 := time.hour
			elseif f2 = 'm' then
				i2 := time.minute
			else
				check f2 = 's' end
				i2 := time.second
			end
			if f3 = 'h' then
				i3 := time.hour
			elseif f3 = 'm' then
				i3 := time.minute
			else
				check f3 = 's' end
				i3 := time.second
			end
			Result := fmtr.formatted (i1)
			Result.append (fs)
			Result.append (fmtr.formatted (i2))
			Result.append (fs)
			Result.append (fmtr.formatted (i3))
		end

	month_table: HASH_TABLE [INTEGER, STRING] is
			-- Table of 3-letter month abbreviations mapped to the
			-- respective integer value for the month
		local
			months: ARRAY [STRING]
			i: INTEGER
		once
			create Result.make (12)
			months := <<"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
				"Aug", "Sep", "Oct", "Nov", "Dec">>
			from i := months.lower until i = months.upper + 1 loop
				Result.extend (i, months @ i)
				i := i + 1
			end
		end

	day_of_week_table: HASH_TABLE [INTEGER, STRING] is
			-- Table of 3-letter day-of-week abbreviations mapped to the
			-- respective integer value for the days of the week
		local
			days_of_the_week: ARRAY [STRING]
			i: INTEGER
		once
			create Result.make (12)
			days_of_the_week :=
				<<"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat">>
			from
				i := days_of_the_week.lower
			until
				i = days_of_the_week.upper + 1
			loop
				Result.extend (i, days_of_the_week @ i)
				i := i + 1
			end
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
			create Result.make
		end

invariant

	month_table_setup: month_table /= Void and then month_table.count = 12 and
		month_table @ "Jan" = 1 and month_table @ "Feb" = 2 and
		month_table @ "Mar" = 3 and month_table @ "Apr" = 4 and
		month_table @ "May" = 5 and month_table @ "Jun" = 6 and
		month_table @ "Jul" = 7 and month_table @ "Aug" = 8 and
		month_table @ "Sep" = 9 and month_table @ "Oct" = 10 and
		month_table @ "Nov" = 11 and month_table @ "Dec" = 12

end
