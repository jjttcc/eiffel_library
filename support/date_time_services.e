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
