indexing
	description: "Command-line user interface functionality"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class COMMAND_LINE_UTILITIES [G] inherit

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

feature -- Access

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

	integer_selection (msg: STRING): INTEGER is
			-- User-selected integer value
		do
			print_list (<<"Enter an integer value for ", msg, ": ">>)
			read_integer
			Result := last_integer
		end

	real_selection (msg: STRING): REAL is
			-- User-selected real value
		do
			print_list (<<"Enter a real value for ", msg, ": ">>)
			read_real
			Result := last_real
		end

	multilist_selection (lists: ARRAY [PAIR [LIST [STRING], STRING]];
				general_msg: STRING): INTEGER is
			-- User's selection of one element from one of the `lists'.
			-- Display all lists in `lists' that are not empty and return
			-- the relative position of the selected item.  For example,
			-- if the first list has a count of 5 and the 2nd item in the
			-- 2nd list is selected, return a value of 7 (5 + 2).
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
		require
			not_negative: i >= 0
		do
			!!Result.make (i)
			Result.fill_blank
		end

feature -- Miscellaneous

	print_object_tree (o: G; level: INTEGER) is
			-- Print the type name of `o' and, recursively, that of all
			-- of its operands.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i = level
			loop
				print ("  ")
				i := i + 1
			end
			print_list (<<o.generator, "%N">>)
			debug ("object_editing")
				print_list (<<"(", o.out, ")%N">>)
			end
			print_component_trees (o, level + 1)
		end

	print_message (msg: STRING) is
			-- Print `msg' to standard out, appending a newline.
		do
			print_list (<<msg, "%N">>)
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

	do_choice (descr: STRING; choices: LIST [PAIR [STRING, BOOLEAN]];
				allowed_selections: INTEGER) is
			-- Implementation, needed by some children, of procedure for
			-- obtaining a desired list of selections from the user -
			-- resulting in the right member of each pair in `choices'
			-- set to true and the right member of all other pairs
			-- set to false.
		local
			finished, choice_made: BOOLEAN
			slimit: INTEGER
			names: ARRAYED_LIST [STRING]
		do
			from
				slimit := allowed_selections
				print_list (<<descr, "%N(Up to ",
							allowed_selections, " choices)%N">>)
				from
					!!names.make (choices.count)
					choices.start
				until
					choices.exhausted
				loop
					names.extend (choices.item.left)
					choices.forth
				end
			until
				slimit = 0 or finished
			loop
				from
					choice_made := false
				until
					choice_made
				loop
					print ("Select an item (0 to end):%N")
					print_names_in_1_column (names, 1)
					read_integer
					if last_integer <= -1 or last_integer > choices.count then
						print_list (<<"Selection must be between 0 and ",
									choices.count, "%N">>)
					elseif last_integer = 0 then
						finished := true
						choice_made := true
					else
						print_list (<<"Added %"", names @ last_integer,
									"%"%N">>)
						choices.i_th (last_integer).set_right (true)
						choice_made := true
					end
				end
				slimit := slimit - 1
			end
		end

feature {NONE} -- Implementation - Hook methods

	print_component_trees (o: G; level: INTEGER) is
			-- Call print_object_tree on all of `o's G-typed components,
			-- if it has any.  Default null implementation for children
			-- who don't need tool.
		do
		end

end -- class COMMAND_LINE_UTILITIES
