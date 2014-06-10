note
	description: "Utility services related to dates and times"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	DATE_TIME_SERVICES

feature -- Access

	date_from_number (value: INTEGER): DATE
			-- Date produced from `value', which must be in the form
			-- yyyymmdd.  If `value' specifies an invalid date, the
			-- result will be Void.
		local
			y, m, d: INTEGER
		do
			create Result.make_now
			if value < 10000 then
				Result := Void
			else
				y := value // 10000
				m := value \\ 10000 // 100
				d := value \\ 100
				Result := date_from_y_m_d (y, m, d)
			end
		end

	date_from_y_m_d (y, m, d: INTEGER): DATE
			-- Date produced from `y', `m', `d' - year, month date
			-- If any of `y', `m', or `d' are invalid, the
			-- result will be Void.
		do
			create Result.make_now
			if
				y < 0 or m < 1 or m > Result.months_in_year or
				d < 1 or d > Result.days_in_i_th_month (m, y)
			then
				Result := Void
			else
				create Result.make (y, m, d)
			end
		end

	date_from_string (d, separator: STRING): DATE
			-- Date from `d' in the form yyyyXmmXdd, where X is the
			-- value of `separator' - for example, "/" when `d' is in
			-- the format yyyy/mm/dd.  If the format of `d' is invalid,
			-- the result will be Void.
		require
			args_exist: d /= Void and separator /= Void
		local
			components: LIST [STRING]
		do
			string_tool.set_target (d)
			components := string_tool.tokens (separator)
			if
				components.count = 3 and (components @ (1)).is_integer and
						(components @ (2)).is_integer and
						(components @ (3)).is_integer
			then
				create Result.make ((components @ (1)).to_integer,
								(components @ (2)).to_integer, 
								(components @ (3)).to_integer)
			end
		end

	date_from_formatted_string (d, field_separator: STRING; y_index,
		m_index, d_index: INTEGER; two_digit_year_partition: INTEGER): DATE
			-- Date from the string `d' in the form [field1]X[field2]X[field3],
			-- where X is the value of `field_separator' and `y_index`,
			-- `m_index', and `d_index' specify which of "field1", "field2",
			-- and "field3" is the year, month, and day, respectively, and
			-- where two_digit_year_partition is either -1 if the year is in
			-- standard (yyyy) format or, if the year in two-digit (yy)
			-- format, gives the partition value for which the century of
			-- the result is the 1990s if the year y from `d' is >
			-- two_digit_year_partition and the 2000s if y <=
			-- two_digit_year_partition.
			-- If the format of `d' is invalid or the values of `y_index`,
			-- `m_index', or `d_index' are invalid, the result will be Void.
		require
			args_exist: d /= Void and field_separator /= Void
			partition_valid: two_digit_year_partition = -1 or
				two_digit_year_partition > 0
		do
			Result := date_from_string_implementation (d, field_separator,
				y_index, m_index, d_index, two_digit_year_partition, False)
		ensure
			void_if_indexes_invalid: (y_index <= 0 or y_index > 3) or
				(m_index <= 0 or m_index > 3) or
				(d_index <= 0 or d_index > 3) implies Result = Void
			void_if_indexes_equal: (y_index = m_index or y_index = d_index or
				m_index = d_index) implies Result = Void
		end

	date_from_month_abbrev_string (d, field_separator: STRING; y_index,
		m_index, d_index: INTEGER; two_digit_year_partition: INTEGER): DATE
			-- Date from the string `d' (where the month field is a 3-letter
			-- abbreviation - "Jan", etc.) in the form
			-- [field1]X[field2]X[field3], where X is the value of
			-- `field_separator' and `y_index`, `m_index', and `d_index'
			-- specify which of "field1", "field2", and "field3" is the year,
			-- month, and day, respectively, and where
			-- two_digit_year_partition is either -1 if the year is in
			-- standard (yyyy) format or, if the year in two-digit (yy)
			-- format, gives the partition value for which the century of
			-- the result is the 1990s if the year y from `d' is <
			-- two_digit_year_partition and the 2000s if y >=
			-- two_digit_year_partition.
			-- If the format of `d' is invalid or the values of `y_index`,
			-- `m_index', or `d_index' are invalid, the result will be Void.
		require
			args_exist: d /= Void and field_separator /= Void
			partition_valid: two_digit_year_partition = -1 or
				two_digit_year_partition > 0
		do
			Result := date_from_string_implementation (d, field_separator,
				y_index, m_index, d_index, two_digit_year_partition, True)
		ensure
			void_if_indexes_invalid: (y_index <= 0 or y_index > 3) or
				(m_index <= 0 or m_index > 3) or
				(d_index <= 0 or d_index > 3) implies Result = Void
			void_if_indexes_equal: (y_index = m_index or y_index = d_index or
				m_index = d_index) implies Result = Void
		end

	time_from_string (t, separator: STRING): TIME
			-- Time produced from `t', which must be in the form
			-- hhXmm[Xss], where X denotes the character specified by
			-- `separator' and [Xss] means that the seconds component is
			-- optional.  If `t' specifies an invalid time, the
			-- result will be Void.
		require
			t_not_void: t /= Void
			separator_valid: separator /= Void and separator.count = 1
		local
			h, m, s, count: INTEGER
			tokens: LIST [STRING]
		do
			string_tool.set_target (t)
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

	month_from_3_letter_abbreviation (m: STRING): INTEGER
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

	day_of_week_from_3_letter_abbreviation (d: STRING): INTEGER
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

	adjusted_2_digit_year (year, two_digit_year_partition: INTEGER): INTEGER
			-- Year value adjusted for 2-digit years according to
			-- `two_digit_year_partition'
		require
			partition_valid: two_digit_year_partition > 0
		do
			if year > two_digit_year_partition then
				Result := year + 1900
			else
				check
					not_greater_than: year <= two_digit_year_partition
				end
				Result := year + 2000
			end
		ensure
			after_1900: Result > 1900
			before_2000_if_year_higher:
				year > two_digit_year_partition implies Result < 2000
			after_2000_if_year_not_higher:
				year <= two_digit_year_partition implies Result >= 2000
		end

	year_month_day (date_components: LIST [STRING]; y_index, m_index,
		d_index: INTEGER; three_letter_month: BOOLEAN): ARRAY [INTEGER]
			-- `date_components' as a 3-element array, where:
			-- Result @ 1 is the year
			-- Result @ 2 is the month
			-- Result @ 3 is the day
			-- and where `y_index', m`_index', and d`_index' specify the
			-- year, month, and date fields of `date_components',
			-- respectively and where `three_letter_month' specifies
			-- whether the month field in `date_components' is a 3-letter
			-- abbreviation ("Jan", "Feb", etc.).  If `date_components' is
			-- invalid, Result will be <<-1, -1, -1>>.
		require
			valid_indexes: (y_index > 0 and y_index <= 3) and
				(m_index > 0 and m_index <= 3) and
				(d_index > 0 and d_index <= 3)
			valid_indexes2: not (y_index = m_index or y_index = d_index or
				m_index = d_index)
			date_components_valid: date_components /= Void and then
				date_components.count = 3
		local
			y, m, d: INTEGER
		do
			y := 1; m := 2; d := 3
			Result := <<-1, -1, -1>>
			if (date_components @ y_index).is_integer then
				Result.put ((date_components @ y_index).to_integer, y)
			end
			if three_letter_month then
				-- Month field is "Jan", "Feb", etc.
				if month_table.has (date_components @ m_index) then
					Result.put (month_from_3_letter_abbreviation (
						date_components @ m_index), m)
				end
			else
				if (date_components @ m_index).is_integer then
					Result.put ((date_components @ m_index).to_integer, m)
				end
			end
			if (date_components @ d_index).is_integer then
				Result.put ((date_components @ d_index).to_integer, d)
			end
		ensure
			normal_lower_upper: Result /= Void and then Result.lower = 1 and
				Result.upper = 3
		end

	current_date: DATE
		do
			create Result.make_now
		end

	current_time: TIME
		do
			create Result.make_now
		end

	date_as_yyyymmdd (date: DATE): STRING
			-- `date' formatted as yyyymmdd
		do
			Result := formatted_date (date, 'y', 'm', 'd', "")
		end

	formatted_date (date: DATE; f1, f2, f3: CHARACTER; fs: STRING): STRING
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

	formatted_time (time: TIME; f1, f2, f3: CHARACTER; fs: STRING): STRING
			-- Formatted `time', with hour, minute, and second in the order
			-- specified by `f1', `f2', and `f3', separated by `fs'.  If
			-- `fs' is empty, no field separator is used.
		require
			fields_h_m_or_s:
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

	month_table: HASH_TABLE [INTEGER, STRING]
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

	day_of_week_table: HASH_TABLE [INTEGER, STRING]
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

	date_time_duration_in_minutes (d: DATE_TIME_DURATION): INTEGER
			-- Total number of minutes in `d', ignoring `d.month' and
			-- `d.year', and `d.second'
		require
			d_exists: d /= Void
		do
			Result := d.minute + d.minutes_in_hour * d.hour
			if not equal (d.date, d.date.zero) then
				Result := Result + d.minutes_in_hour * d.hours_in_day * d.day
			end
		end

	time_duration_in_minutes (d: TIME_DURATION): INTEGER
			-- Total number of minutes in `d', ignoring `d.second'
		require
			d_exists: d /= Void
		do
			Result := d.minute + d.minutes_in_hour * d.hour
		end

feature -- Status report

	hour_valid (h: INTEGER): BOOLEAN
			-- Is `h' a valid hour?
		do
			Result := h >= 0 and h < work_time.hours_in_day
		end

	minute_valid (m: INTEGER): BOOLEAN
			-- Is `m' a valid minute?
		do
			Result := m >= 0 and m < work_time.minutes_in_hour
		end

	second_valid (s: INTEGER): BOOLEAN
			-- Is `s' a valid second?
		do
			Result := s >= 0 and s < work_time.seconds_in_minute
		end

feature  {NONE} -- Implementation

	work_time: TIME
		once
			create Result.make (0, 0, 0)
		end

	string_tool: STRING_UTILITIES
		once
			create Result.make
		end

	date_from_string_implementation (d, field_separator: STRING; y_index,
		m_index, d_index: INTEGER; two_digit_year_partition: INTEGER;
		three_letter_month: BOOLEAN): DATE
			-- Implementation of `date_from_2_digit_year_string' and
			-- `date_from_month_abbrev_string'
		require
			args_exist: d /= Void and field_separator /= Void
			partition_valid: two_digit_year_partition = -1 or
				two_digit_year_partition > 0
		local
			components: LIST [STRING]
			su: expanded STRING_UTILITIES
			date: ARRAY [INTEGER]
		do
			su.set_target (d)
			components := su.tokens (field_separator)
			date := year_month_day (components, y_index, m_index, d_index,
				three_letter_month)
			if date @ 1 /= -1 then
				-- The contents of `components' were valid.
				if two_digit_year_partition > 0 then
					date.put (adjusted_2_digit_year (
						date @ 1, two_digit_year_partition), 1)
				end
				Result := date_from_y_m_d (date @ 1, date @ 2, date @ 3)
			end
		ensure
			void_if_indexes_invalid: (y_index <= 0 or y_index > 3) or
				(m_index <= 0 or m_index > 3) or
				(d_index <= 0 or d_index > 3) implies Result = Void
			void_if_indexes_equal: (y_index = m_index or y_index = d_index or
				m_index = d_index) implies Result = Void
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
