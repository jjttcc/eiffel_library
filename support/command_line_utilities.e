indexing
	description: "Command-line user interface functionality"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	note:
		"This class redefines print from GENERAL.  Classes that inherit from %
		%this class and one or more other classes will need to undefine %
		%the version of print inherited from the other classes."

	date: "$Date$";
	revision: "$Revision$"

class COMMAND_LINE_UTILITIES [G] inherit

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

	NETWORK_PROTOCOL
		rename
			eom as network_eom
		export
			{NONE} all
		undefine
			print
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
				if last_string.count > 0 then
					Result := last_string @ 1
				end
			end
		end

	integer_selection (msg: STRING): INTEGER is
			-- User-selected integer value
		do
			print_list (<<"Enter an integer value for ", msg, ": ", eom>>)
			read_integer
			Result := last_integer
		end

	real_selection (msg: STRING): REAL is
			-- User-selected real value
		do
			print_list (<<"Enter a real value for ", msg, ": ", eom>>)
			read_real
			Result := last_real
		end

	string_selection (msg: STRING): STRING is
			-- User-selected real value
		do
			print_list (<<msg, ": ", eom>>)
			read_line
			Result := clone (last_string)
		end

	list_selection (l: LIST [STRING]; general_msg: STRING): INTEGER is
			-- User's selection from an element of `l'
		local
			i, startnum: INTEGER
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
					Result := last_integer
				end
			end
		ensure
			in_range: Result >= 1 and result <= l.count
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
			!!Result.make (i)
			Result.fill_blank
		end

feature -- Input

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
					print_names_in_1_column (names, 1); print (eom)
					read_integer
					if
						last_integer <= -1 or
						last_integer > choices.count
					then
						print_list (<<"Selection must be between 0 and ",
									choices.count, "%N">>)
					elseif last_integer = 0 then
						finished := true
						choice_made := true
					else
						print_list (
								<<"Added %"", names @ last_integer,
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

feature {NONE} -- Implementation

	input_device, output_device: IO_MEDIUM
			-- Input/output media to which all input will be sent and
			-- from which output will be received, respectively

	last_integer: INTEGER
			-- Last integer input with `read_integer'

	last_real: REAL
			-- Last real input with `read_real'

	last_string: STRING
			-- Last string input with `read_line'

	print (o: GENERAL) is
			-- Redefinition of output method inherited from GENERAL to
			-- send output to output_device
		do
			if o /= Void then
				output_device.put_string (o.out)
			end
		end

	eom: STRING is
			-- End of message indicator - "<Ctl>G" for stream socket,
			-- "" (empty string) for files (including stdin) and other types
		local
			file: FILE
			stream_socket: STREAM_SOCKET
		do
			if eom_cache = Void then
				file ?= input_device
				stream_socket ?= input_device
				if file /= Void then
					eom_cache := ""
				elseif stream_socket /= Void then
					eom_cache := network_eom
				else
					eom_cache := ""
				end
			end
			Result := eom_cache
		end

	eom_cache: STRING

	output_date_field_separator: STRING is "/"

end -- class COMMAND_LINE_UTILITIES
