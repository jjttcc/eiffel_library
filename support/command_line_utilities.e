indexing
	description: "Command-line user interface functionality"
	note:
		"This class redefines print from GENERAL.  Classes that inherit from %
		%this class and one or more other classes will need to undefine %
		%the version of print inherited from the other classes."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class COMMAND_LINE_UTILITIES inherit

	ANY
		redefine
			print
		end

	GENERAL_UTILITIES
		export
			{NONE} all
		undefine
			print
		end

	SINGLE_MATH
		export {NONE}
			all
		undefine
			print
		end

feature {NONE} -- Access

	character_selection (msg: STRING): CHARACTER is
			-- User-selected character
		do
			if msg /= Void and not msg.is_empty then
				print_list (<<msg, eom>>)
			end
			from
				Result := '%U'
			until
				Result /= '%U'
			loop
				read_line
				if last_string.count > 0 then
					Result := last_string @ 1
				end
			end
		end

	integer_selection (msg: STRING): INTEGER is
			-- User-selected integer value
		do
			if msg /= Void and not msg.is_empty then
				print_list (<<"Enter an integer value for ", msg, " ", eom>>)
			end
			read_integer
			Result := last_integer
		end

	real_selection (msg: STRING): REAL is
			-- User-selected real value
		do
			if msg /= Void and not msg.is_empty then
				print_list (<<"Enter a real value for ", msg, " ", eom>>)
			end
			read_real
			Result := last_real
		end

	string_selection (msg: STRING): STRING is
			-- User-selected real value
		do
			if msg /= Void and not msg.is_empty then
				print_list (<<msg, " ", eom>>)
			end
			read_line
			Result := clone (last_string)
		ensure
			Result_exists: Result /= Void
		end

	list_selection (l: LIST [STRING]; general_msg: STRING): INTEGER is
			-- User's selection from an element of `l'
		do
			print_list (<<general_msg, "%N">>)
			from
			until
				Result /= 0
			loop
				print_names_in_1_column (l, 1)
				print (eom)
				read_integer
				if
					last_integer < 1 or
						last_integer > l.count
				then
					print_list (<<"Selection must be between 1 and ",
								l.count, "%N">>)
				else
					inspect
						character_selection (concatenation (
							<<"Select ", l @ last_integer, "? (y/n) ">>))
					when 'y', 'Y' then
						Result := last_integer
					else
					end
				end
			end
		ensure
			in_range: Result >= 1 and Result <= l.count
		end

	backoutable_selection (l: LIST [STRING]; msg: STRING;
				exit_value: INTEGER): INTEGER is
			-- User's selection from an element of `l', which can be
			-- backed out of by entering 0 - `exit_value' is the value to
			-- return to indicate the the user has backed out.
		local
			finished: BOOLEAN
		do
			from
				if l.count = 0 then
					finished := True
					Result := exit_value
					print ("There are no items to edit.%N")
				end
			until
				finished
			loop
				print_list (<<msg, ":%N">>)
				print_names_in_1_column (l, 1)
				print ("(0 to end) ")
				print (eom)
				read_integer
				if
					last_integer < 0 or
						last_integer > l.count
				then
					print_list (<<"Selection must be between 0 and ",
								l.count, "%N">>)
				elseif last_integer = 0 then
					finished := True
					Result := exit_value
				else
					check
						valid_index: last_integer > 0 and
									last_integer <= l.count
					end
					finished := True
					Result := last_integer
				end
			end
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
				print (eom)
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
			create Result.make (i)
			Result.fill_blank
		end

	input_device, output_device: IO_MEDIUM
			-- Input/output media to which all input will be sent and
			-- from which output will be received, respectively

feature {NONE} -- Input

	read_integer is
			-- Input an integer (as a sequence of digits terminated with
			-- a newline) and place the result in `last_integer'.  If
			-- any non-digits are included in the input, last_integer is
			-- set to 0.
		do
			input_device.read_line
			if input_device.last_string.is_integer then
				last_integer := input_device.last_string.to_integer
			else
				last_integer := 0
			end
		end

	read_real is
			-- Input a real (as a sequence of characters terminated with
			-- a newline) and place the result in `last_real'.  If the
			-- entered characters do not make up a real value, last_real is
			-- set to 0.
		do
			input_device.read_line
			if input_device.last_string.is_real then
				last_real := input_device.last_string.to_real
			else
				last_real := 0
			end
		end

	read_line is
			-- Input a string and place it in `last_string'.
		do
			input_device.read_line
			last_string := input_device.last_string
		end

feature {NONE} -- Miscellaneous

	print_message (msg: STRING) is
			-- Print `msg' to standard out, appending a newline.
		do
			print_list (<<msg, "%N">>)
		end

	print_row (names: LIST [STRING]; row, rows, cols, namecount,
			column_pivot, row_width: INTEGER) is
		local
			column, i: INTEGER
		do
			from column := 1 until
				column = cols or
				(row = rows and column_pivot > 0 and column > column_pivot)
			loop
				if column_pivot > 0 and column - 1 > column_pivot then
					i := row + rows * column_pivot +
						(rows - 1) * (column - 1 - column_pivot)
				else
					i := row + rows * (column - 1)
				end
				if i <= namecount then
					print_list (<<i, ") ", names @ i,
						spaces ((row_width / cols - (floor (log10 (i)) +
						cols - 1 + names.i_th(i).count)).ceiling)>>)
				end
				column := column + 1
			end
			if
				not (row = rows and column_pivot > 0 and column > column_pivot)
			then
				if column_pivot > 0 and column - 1 > column_pivot then
					i := row + rows * column_pivot +
						(rows - 1) * (column - 1 - column_pivot)
				else
					i := row + rows * (column - 1)
				end
				if i <= namecount then
					print_list (<<i, ") ", names @ i>>)
				end
			end
			print ("%N")
		end

	print_names_in_n_columns (names: LIST [STRING]; cols: INTEGER) is
			-- Print each element of `names' as a numbered item
			-- to the screen in `cols' columns.
		local
			width, rows, row, end_index, namecount, col_pivot: INTEGER
		do
			width := 76
			namecount := names.count
			rows := (namecount + cols - 1) // cols
			col_pivot := namecount \\ cols
			end_index := rows * cols
			row := 1
			from
			until
				row = rows + 1
			loop
				print_row(names, row, rows, cols, namecount, col_pivot, width)
				row := row + 1
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
					create names.make (choices.count)
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
					choice_made := False
				until
					choice_made
				loop
					print ("Select an item (0 to end):%N")
					print_names_in_1_column (names, 1); print (eom)
					read_integer
					if
						last_integer <= -1 or
						last_integer > choices.count
					then
						print_list (<<"Selection must be between 0 and ",
									choices.count, "%N">>)
					elseif last_integer = 0 then
						finished := True
						choice_made := True
					else
						print_list (
								<<"Added %"", names @ last_integer,
								"%"%N">>)
						choices.i_th (last_integer).set_right (True)
						choice_made := True
					end
				end
				slimit := slimit - 1
			end
		end

feature {NONE} -- Implementation

	last_integer: INTEGER
			-- Last integer input with `read_integer'

	last_real: REAL
			-- Last real input with `read_real'

	last_string: STRING
			-- Last string input with `read_line'

	print (o: ANY) is
			-- Redefinition of output method inherited from GENERAL to
			-- send output to output_device
		do
			if o /= Void then
				output_device.put_string (o.out)
			end
		end

	eom: STRING is
			-- End-of-message string - redefine if needed
		once
			Result := ""
		end

end
