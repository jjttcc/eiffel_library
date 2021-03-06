note
	description: "Generic sorting-related utilities"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class

	GENERIC_SORTING [G -> PART_COMPARABLE, H -> HASHABLE]

feature -- Access

	sorted_list (l: LINEAR [G]): PART_SORTED_TWO_WAY_LIST [G]
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

	sorted_set (l: LINEAR [G]): PART_SORTED_SET [G]
			-- All elements of `l', sorted, with duplicates removed
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
		end

	duplicates (l: LIST [H]): BOOLEAN
			-- Are there any items with duplicates in `l'?
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
					Result := True
				else
					tbl.put (l.item, l.item)
					l.forth
				end
			end
		end

	is_sorted_ascending (l: LINEAR [PART_COMPARABLE]): BOOLEAN
			-- Is `l' sorted in ascending order?
		local
			prev: PART_COMPARABLE
		do
			Result := True
			from
				l.start
				if not l.exhausted then
					prev := l.item
					l.forth
				end
			until
				not Result or l.exhausted
			loop
				if l.item < prev then
					Result := False
				end
				prev := l.item
				l.forth
			end
		end

	is_sorted_descending (l: LINEAR [PART_COMPARABLE]): BOOLEAN
			-- Is `l' sorted in descending order?
		local
			prev: PART_COMPARABLE
		do
			Result := True
			from
				l.start
				if not l.exhausted then
					prev := l.item
					l.forth
				end
			until
				not Result or l.exhausted
			loop
				if l.item > prev then
					Result := False
				end
				prev := l.item
				l.forth
			end
		end

end -- class GENERIC_SORTING
