indexing
	description: "Utility for storing a set of boolean states"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	STATE_SET

feature -- Access

	state_count: INTEGER is 32
			-- Total number of states

	item, infix "@" (i: INTEGER): BOOLEAN is
			-- The state at position `i'
		require
			index_large_enough: i >= 1
			index_small_enough: i <= state_count
		local
			x: INTEGER
		do
			Result := x.one.bit_shift_left (i - 1) & bits /= 0
		end

	put (value: BOOLEAN; i: INTEGER) is
			-- Set the `i'th bit: 1 if `value' = True, 0 if `value' = False.
		require
			index_large_enough: i >= 1
			index_small_enough: i <= state_count
		local
			x: INTEGER
		do
			x := x.one.bit_shift_left (i - 1)
			if value then
				bits := bits | x
			else
				bits := bits & x.bit_not
			end
		end

	status: STRING is
			-- Report of all states as a string ordered from right to left,
			-- where 0 represents false and 1 represents True - e.g.:
			-- "00000000000000000000000000001010" shows item (2) and
			-- item (4) as True and the rest as False.
		local
			i: INTEGER
		do
			from
				Result := "00000000000000000000000000000000"
				i := 1
			until
				i > state_count
			loop
				if item (i) then
					Result.put ('1', state_count - i + 1)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	bits: INTEGER

end
