indexing
	description: "General utility routines"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

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
			!!Result.make (0)
			from
				i := 1
			until
				i = a.count + 1
			loop
				Result.append ((a @ i).out)
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

end -- class GENERAL_UTILITIES
