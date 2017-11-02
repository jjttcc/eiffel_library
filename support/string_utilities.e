note
	description: "STRING manipulation utility routines";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class STRING_UTILITIES inherit

creation

	make, default_create

feature {NONE} -- Initialization

	make
		do
		ensure then
			target_void: target = Void
		end

feature -- Initialization

	set_target (s: STRING)
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

	tokens (fld_sep: STRING): ARRAYED_LIST [STRING]
			-- Tokenized list of all components of `target' separated by
			-- `fld_sep'.  If `fld_sep' does not occur in `target' Result
			-- will contain one element whose contents equal `target'.
		require
			s_not_void: fld_sep /= Void
			s_not_empty: not fld_sep.is_empty
			target_not_void: target /= Void
		local
			i, last_index, s_count: INTEGER
		do
			create Result.make (0)
			last_index := 0
			if not target.is_empty then
				last_index := target.substring_index (fld_sep, 1)
			end
			if last_index = 0 then
				Result.extend (target)
			else
				from
					check last_index > 0 end
					s_count := fld_sep.count
					Result.extend (target.substring (1, last_index - 1))
					i := last_index + s_count
				until
					last_index = 0
				loop
					if i > target.count then
						last_index := 0
						-- `fld_sep' occurred at the end of target, resulting
						-- in an empty field
						Result.extend ("")
					else
						last_index := target.substring_index (fld_sep, i)
						if last_index > 0 then
							Result.extend (target.substring (i, last_index - 1))
							i := last_index + s_count
						else
							Result.extend (target.substring (i, target.count))
						end
					end
				end
			end
		ensure
			result_exists: Result /= Void
			target.is_empty implies Result.count = 1 and Result.first.is_empty
		end

	tokens_with_limit (fld_sep: STRING; limit: INTEGER): ARRAYED_LIST [STRING]
			-- Tokenized list of all components of `target' separated by
			-- `fld_sep'.  If `fld_sep' does not occur in `target' Result
			-- will contain one element whose contents equal `target'.
			-- If `limit' is >= 0 tokenizing will stop as soon as `limit`
			-- tokens are produced.  For example, if `target' is
			-- "one,two,three,four,five,six" `fld_sep' is ',', and `limit' is
			-- 4, Result will be: <<one, two, three, four>>.  If `limit'
			-- is 0, Result will be <<>> (empty).  If `limit' is < 0, it
			-- will be ignored - all tokens will be extracted.
		require
			s_not_void: fld_sep /= Void
			s_not_empty: not fld_sep.is_empty
			target_not_void: target /= Void
		local
			i, last_index, s_count, token_count: INTEGER
		do
			create Result.make (0)
			token_count := 0; last_index := 0
			if not target.is_empty then
				last_index := target.substring_index (fld_sep, 1)
			end
			if last_index = 0 and limit /= 0 then
				Result.extend (target)
			else
				from
					check last_index > 0 end
					s_count := fld_sep.count
					if limit >= 0 and token_count < limit then
						Result.extend (target.substring (1, last_index - 1))
						i := last_index + s_count
						token_count := token_count + 1
					end
				until
					last_index = 0 or token_count = limit
				loop
					if i > target.count then
						last_index := 0
						-- `fld_sep' occurred at the end of target, resulting
						-- in an empty field
						Result.extend ("")
					else
						last_index := target.substring_index (fld_sep, i)
						if last_index > 0 then
							Result.extend (target.substring (i, last_index - 1))
							i := last_index + s_count
						else
							Result.extend (target.substring (i, target.count))
						end
					end
					token_count := token_count + 1
				end
			end
		ensure
			result_exists: Result /= Void
			target.is_empty implies Result.count = 1 and Result.first.is_empty
		end

	pluralized(s: STRING; count: INTEGER): STRING
			-- Make `s` plural - by appending an 's' - if `count' /= 1
		do
			Result := s
			if count /= 1 then
				Result := Result + "s"
			end
		end

feature -- Element change

	keep_tail (c: CHARACTER)
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
-- !!!!check if this change is correct.
				target.keep_tail (target.count - last_index)
			end
		ensure
			no_c: not target.has (c)
		end

	keep_head (c: CHARACTER)
			-- Remove all characters of `target' from `c' to the end.
		require
			target_not_void: target /= Void
			has_c: target.has (c)
		do
-- !!!!check if this change is correct.
			target.keep_head (target.index_of (c, 1) - 1)
		ensure
			no_c: not target.has (c)
		end

end -- class STRING_UTILITIES
