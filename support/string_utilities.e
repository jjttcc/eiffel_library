indexing
	description: "STRING manipulation utility routines";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class STRING_UTILITIES inherit

creation

	make

feature -- Initialization

	make (s: STRING) is
			-- Set `target' to s
		require
			not_void: s /= Void
		do
			target := s
		ensure
			set: target = s
		end

feature -- Access

	target: STRING
			-- The target string to operate on

	tokens (s: STRING): ARRAYED_LIST [STRING] is
			-- Tokenized list of all components of `target' separated by `s'.
			-- If `s' does not occur in `target' Result will contain one
			-- element whose contents equal `target'.
		require
			s_not_void: s /= Void
			s_not_empty: not s.empty
			target_not_void: target /= Void
			target_not_empty: not target.empty
		local
			i, last_index: INTEGER
		do
			create Result.make (0)
			last_index := target.substring_index (s, 1)
			if last_index = 0 then
				Result.extend (target)
			else
				from
					check last_index > 0 end
					Result.extend (target.substring (1, last_index - 1))
					i := last_index + 1
				until
					last_index = 0
				loop
					if i > target.count then
						last_index := 0
						-- `s' occurred at the end of target, resulting
						-- in an empty field
						Result.extend ("")
					else
						last_index := target.substring_index (s, i)
						if last_index > 0 then
							Result.extend (target.substring (i, last_index - 1))
							i := last_index + 1
						else
							Result.extend (target.substring (i, target.count))
						end
					end
				end
			end
		end

feature -- Element change

	tail (c: CHARACTER) is
			-- Remove all characters of `target' up to the last occurrence
			-- of `c'.
		require
			target_not_void: target /= Void
			has_c: target.has (c)
		local
			i, last_index: INTEGER
		do
			from
				i := 1
				last_index := 0
			until
				i = 0
			loop
				if i + 1 <= target.count then
					i := target.index_of (c, i + 1)
				else
					i := 0
				end
				if i /= 0 then
					last_index := i
				end
			end
			if last_index > 0 then
				target.tail (target.count - last_index)
			end
		ensure
			no_c: not target.has (c)
		end

	head (c: CHARACTER) is
			-- Remove all characters of `target' from `c' to the end.
		require
			target_not_void: target /= Void
			has_c: target.has (c)
		local
			i, last_index: INTEGER
		do
			target.head (target.index_of (c, 1) - 1)
		ensure
			no_c: not target.has (c)
		end

end -- class STRING_UTILITIES
