indexing
	description: "Command-line user interface functionality"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
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

	character_selection (msg: STRING): CHARACTER is
			-- User-selected character
		do
			if msg /= Void and not msg.empty then
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
			if msg /= Void and not msg.empty then
				print_list (<<"Enter an integer value for ", msg, ": ", eom>>)
			end
			read_integer
			Result := last_integer
		end

	real_selection (msg: STRING): REAL is
			-- User-selected real value
		do
			if msg /= Void and not msg.empty then
				print_list (<<"Enter a real value for ", msg, ": ", eom>>)
			end
			read_real
			Result := last_real
		end

	string_selection (msg: STRING): STRING is
			-- User-selected real value
		do
			if msg /= Void and not msg.empty then
				print_list (<<msg, ": ", eom>>)
			end
			read_line
			Result := clone (last_string)
		end

	date_time_selection (msg: STRING): DATE_TIME is
			-- Obtain the date and time to begin market analysis from the
			-- user and pass it to the event generators.
		local
			date: DATE
			time: TIME
			finished: BOOLEAN
		do
			create date.make_now
			create time.make_now
			if msg /= Void and not msg.empty then
				print_list (<<msg, "%N">>)
			end
			from
			until
				finished
			loop
				print_list (<<"Currently selected date and time: ", date, ", ",
								time, "%N">>)
				print_list (<<"Select action:",
					"%N     Set date (d) Set time (t) %
					%Set date relative to current date (r)%N%
					%     Set market analysis date %
					%to currently selected date (s)%N", eom>>)
				inspect
					character_selection (Void)
				when 'd', 'D' then
					date := date_choice
				when 't', 'T' then
					time := time_choice
				when 'r', 'R' then
					date := relative_date_choice
				when 's', 'S' then
					finished := True
				else
					print ("Invalid selection%N")
				end
				print ("%N%N")
			end
			create Result.make_by_date_time (date, time)
			print_list (<<"Setting date and time for processing to ",
							Result.out, "%N">>)
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

	output_time_field_separator: STRING is ":"

feature {NONE} -- Implementation - date-related routines

	date_choice: DATE is
			-- Date obtained from user.
		do
			print_list (<<"Enter the date to use for analysis or %
				%hit <Enter> to use the%Ncurrent date (mm/dd/yyyy): ", eom>>)
			create Result.make_now
			from
				read_line
			until
				last_string.empty or Result.date_valid (
					last_string, Result.date_default_format_string)
			loop
				print_list (<<"Date format invalid, try again: ", eom>>)
				read_line
			end
			if not last_string.empty then
				create Result.make_from_string_default (last_string)
			end
			print_list (<<"Using date of ", Result, ".%N">>)
		end

	relative_date_choice: DATE is
			-- Date obtained from user.
		local
			period: CHARACTER
			period_name: STRING
		do
			create Result.make_now
			from
			until
				period = 'd' or period = 'm' or period = 'y'
			loop
				print_list (<<"Select period length:%N%
					%     day (d) month (m) year (y) ", eom>>)
				inspect
					character_selection (Void)
				when 'd', 'D' then
					period := 'd'
					period_name := "day"
				when 'm', 'M' then
					period := 'm'
					period_name := "month"
				when 'y', 'Y' then
					period := 'y'
					period_name := "year"
				else
					print ("Invalid selection%N")
				end
			end
			print_list (<<"Enter the number of ", period_name,
						"s to set date back relative to today: ", eom>>)
			from
				read_integer
			until
				last_integer >= 0
			loop
				print_list (<<"Invalid number, try again: ", eom>>)
				read_integer
			end
			inspect
				period
			when 'd' then
				Result.day_add (-last_integer)
			when 'm' then
				Result.month_add (-last_integer)
			when 'y' then
				Result.year_add (-last_integer)
			end
			print_list (<<"Using date of ", Result, ".%N">>)
		end

	time_choice: TIME is
			-- Time obtained from user.
		do
			create Result.make (0, 0, 0)
			print_list (<<"Enter the hour to use for analysis: ", eom>>)
			from
				read_integer
			until
				last_integer >= 0 and last_integer < Result.Hours_in_day
			loop
				print_list (<<"Invalid hour, try again: ", eom>>)
				read_integer
			end
			Result.set_hour (last_integer)
			print_list (<<"Enter the minute to use for analysis: ", eom>>)
			from
				read_integer
			until
				last_integer >= 0 and last_integer < Result.Minutes_in_hour
			loop
				print_list (<<"Invalid minute, try again: ", eom>>)
				read_integer
			end
			Result.set_minute (last_integer)
			print_list (<<"Using time of ", Result, ".%N">>)
		end


end -- class COMMAND_LINE_UTILITIES
