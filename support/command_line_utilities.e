indexing
	description: "User interface utilities"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

foo
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

	print_names_in_1_column (names: LIST [STRING]) is
			-- Print each element of `names' as a numbered item to the
			-- screen in 1 column.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i = names.count + 1
			loop
				print_list (<<i, ") ", names @ i, "%N">>)
				i := i + 1
			end
		end

end -- class UI_UTILITIES
