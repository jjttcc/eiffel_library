indexing
	description: "General utility routines"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class

	GENERAL_UTILITIES

feature -- Basic operations

	concatenation (a: ARRAY [ANY]): STRING is
			-- A string containing a concatenation of all elements of `a'
		require
			not_void: a /= Void
		local
			i: INTEGER
		do
			create Result.make (0)
			from
				i := 1
			until
				i = a.count + 1
			loop
				if a @ i /= Void then
					Result.append ((a @ i).out)
				end
				i := i + 1
			end
		end

	print_list (l: ARRAY [ANY]) is
			-- Print all members of `l'.
		require
			not_void: l /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i = l.count + 1
			loop
				if l @ i /= Void then
					print (l @ i)
				end
				i := i + 1
			end
		end

	log_error (msg: STRING) is
			-- Log `msg' as an error.
		require
			not_void: msg /= Void
		do
			io.error.put_string (msg)
		end

	log_errors (list: ARRAY [ANY]) is
			-- Log `list' of error messages.
		require
			not_void: list /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i = list.count + 1
			loop
				if list @ i /= Void then
					log_error ((list @ i).out)
				end
				i := i + 1
			end
		end

end -- class GENERAL_UTILITIES
