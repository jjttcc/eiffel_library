indexing
	description: "Utility services related to dates and times"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
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
			if not Result.time_valid (value) then
				Result := Void
			else
				Result.make_from_string (value)
			end
		end

end -- class DATE_TIME_SERVICES
