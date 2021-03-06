note
	description: "Utility for storing a set of boolean states"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class

	STATE_SET

feature -- Access

	state_count: INTEGER = 32
			-- Total number of states

	state_at (i: INTEGER): BOOLEAN
			-- The state at position `i'
		require
			index_large_enough: i >= 1
			index_small_enough: i <= state_count
		local
			x: INTEGER
		do
			Result := x.one.bit_shift_left (i - 1) & bits /= 0
		end

	put_state (value: BOOLEAN; i: INTEGER)
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

	state_set_status: STRING
			-- Report of all states as a string ordered from right to left,
			-- where 0 represents false and 1 represents True - e.g.:
			-- "00000000000000000000000000001010" shows state_at (2) and
			-- state_at (4) as True and the rest as False.
		local
			i: INTEGER
		do
			from
				Result := "00000000000000000000000000000000"
				i := 1
			until
				i > state_count
			loop
				if state_at (i) then
					Result.put ('1', state_count - i + 1)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	bits: INTEGER

end
