indexing
	description: "Generic sorting-related utilities"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class

	GENERIC_SORTING [G -> PART_COMPARABLE, H -> HASHABLE]

feature -- Basic operations

	sorted_list (l: LIST [G]): PART_SORTED_TWO_WAY_LIST [G] is
			-- All elements of `l', sorted
		require
			not_void: l /= Void
		do
			create Result.make
			from
				l.start
			until
				l.exhausted
			loop
				Result.extend (l.item)
				l.forth
			end
		ensure
			sorted: Result.sorted
		end

	duplicates (l: LIST [H]): BOOLEAN is
			-- Are there any items with duplicate names in `l'?
		local
			tbl: HASH_TABLE [H, H]
		do
			from
				l.start
				create tbl.make (l.count)
			until
				Result or l.exhausted
			loop
				if tbl.has (l.item) then
					Result := true
				else
					tbl.put (l.item, l.item)
					l.forth
				end
			end
		end

end -- class GENERIC_SORTING
