indexing
	description: "User interface utilities"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class UI_UTILITIES inherit

	STD_FILES
		export
			{NONE} all
		end

	PRINTING
		export
			{NONE} all
		end

	SINGLE_MATH
		export {NONE}
			all
		end

feature

	selected_character: CHARACTER is
			-- Character selected by user
		do
			from
				Result := '%U'
			until
				Result /= '%U'
			loop
				read_line
				if laststring.count > 0 then
					Result := laststring @ 1
				end
			end
		end

	multilist_selection (lists: ARRAY [PAIR [LIST [STRING], STRING]];
				general_msg: STRING): INTEGER is
		local
			i, startnum: INTEGER
		do
			print (general_msg)
			from
			until
				Result /= 0
			loop
				from
					i := 1; startnum := 1
				until
					i = lists.count + 1
				loop
					if lists.item (i).left.count > 0 then
						print (lists.item (i).right)
						print_names_in_1_column (lists.item (i).left, startnum)
					end
					startnum := startnum + lists.item (i).left.count
					i := i + 1
				end
				check
					-- startnum = the sum of the count of all `left' elements
					-- of lists
				end
				read_integer
				if
					last_integer < 1 or
						last_integer >= startnum
				then
					print_list (<<"Selection must be between 1 and ",
								startnum - 1, "%N">>)
				else
					Result := last_integer
				end
			end
			check
				Result < startnum
			end
		end

	spaces (i: INTEGER): STRING is
			-- `i' spaces
		do
			!!Result.make (i)
			Result.fill_blank
		end

	print_names_in_4_columns (names: LIST [STRING]) is
			-- Print each element of `names' as a numbered item
			-- to the screen in 4 columns.
		local
			cols, width, interval, i, end_index: INTEGER
		do
			cols := 4
			width := 76
			interval := (names.count + cols - 1) // cols
			end_index := interval * cols
			i := 1
			if names.count >= cols then
				from
				until
					i = interval + 1
				loop
					print_list (<<i, ") ",
						names @ i,
						spaces ((width / cols - (floor (log10 (i)) + 3 +
							names.i_th(i).count)).ceiling),
						i + interval, ") ", names @ (i + interval),
						spaces ((width / cols -
							(floor (log10 (i + interval)) + 3 +
								names.i_th(i + interval).count)).ceiling),
						i + interval * 2, ") ", names @ (i + interval * 2)>>)
					if i + interval * 3 <= names.count then
						print_list (<<spaces ((width / cols -
							(floor (log10 (i + interval * 2)) + 3 +
								names.i_th(i + interval * 2).count)).ceiling),
						i + interval * 3, ") ", names @ (i + interval * 3),
						"%N">>)
					else
						print ("%N")
					end
					i := i + 1
				end
			else
				if i <= names.count then
					print_list (<<i, ") ",
						names @ i,
						spaces ((width / cols - (floor (log10 (i)) + 3 +
							names.i_th(i).count)).ceiling)>>)
				end
				if i + interval <= names.count then
					print_list (<<i + interval, ") ", names @ (i + interval),
						spaces ((width / cols -
							(floor (log10 (i + interval)) + 3 +
								names.i_th(i + interval).count)).ceiling)>>)
				end
				if i + interval * 2 <= names.count then
					print_list (<<i + interval * 2, ") ",
						names @ (i + interval * 2),
						spaces ((width / cols -
							(floor (log10 (i + interval * 2)) + 3 +
								names.i_th(i + interval *
								2).count)).ceiling)>>)
				end
				if i + interval * 3 <= names.count then
						print_list (<<i + interval * 3, ") ",
							names @ (i + interval * 3), "%N">>)
				end
				print ("%N")
			end
		end

	print_names_in_1_column (names: LIST [STRING]; first_number: INTEGER) is
			-- Print each element of `names' as a numbered item to the
			-- screen in 1 column.  Numbering is from first_number to
			-- first_number + names.count - 1.
		local
			i: INTEGER
		do
			from
				i := first_number
				names.start
			until
				names.exhausted
			loop
				print_list (<<i, ") ", names.item, "%N">>)
				names.forth
				i := i + 1
			end
			check
				i = first_number + names.count
			end
		end

end -- class UI_UTILITIES
