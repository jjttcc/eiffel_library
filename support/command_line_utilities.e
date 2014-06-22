note
	description: "Command-line user interface functionality"
	note1:
		"This class redefines print from GENERAL.  Classes that inherit from %
		%this class and one or more other classes will need to undefine %
		%the version of print inherited from the other classes."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
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

	EXCEPTIONS
		export
			{NONE} all
		undefine
			print
		end

feature {NONE} -- Access

	character_selection (msg: STRING): CHARACTER
			-- User-selected character
		do
			current_lines_read := 0
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

	integer_selection (msg: STRING): INTEGER
			-- User-selected integer value
		do
			current_lines_read := 0
			if msg /= Void and not msg.is_empty then
				print_list (<<"Enter an integer value for ", msg, " ", eom>>)
			end
			read_integer
			Result := last_integer
		end

	real_selection (msg: STRING): DOUBLE
			-- User-selected real value
		do
			current_lines_read := 0
			if msg /= Void and not msg.is_empty then
				print_list (<<"Enter a real value for ", msg, " ", eom>>)
			end
			read_real
			Result := last_double
		end

	string_selection (msg: STRING): STRING
			-- User-selected real value
		do
			current_lines_read := 0
			if msg /= Void and not msg.is_empty then
				print_list (<<msg, " ", eom>>)
			end
			read_line
			Result := last_string.twin
		ensure
			Result_exists: Result /= Void
		end

	list_selection (l: LIST [STRING]; general_msg: STRING): INTEGER
			-- User's selection from an element of `l'
		do
			current_lines_read := 0
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
				exit_value: INTEGER): INTEGER
			-- User's selection from an element of `l', which can be
			-- backed out of by entering 0 - `exit_value' is the value to
			-- return to indicate the the user has backed out.
		local
			finished: BOOLEAN
		do
			current_lines_read := 0
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
				general_msg: STRING): INTEGER
			-- User's selection of one element from one of the `lists'.
			-- Display all lists in `lists' that are not empty and return
			-- the relative position of the selected item.  For example,
			-- if the first list has a count of 5 and the 2nd item in the
			-- 2nd list is selected, return a value of 7 (5 + 2).
		local
			i, startnum, columns, max_label_size: INTEGER
		do
			current_lines_read := 0
			-- Maximum size of an item label, e.g.: "11) "
			max_label_size := 4
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
						if
							longest_string (lists.item (i).left) +
							max_label_size > Maximum_screen_width / 2
						then
							columns := 1
						else
							columns := 2
						end
						print (lists.item (i).right)
						print_names_in_n_columns (lists.item (i).left, columns,
							startnum)
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

	input_device, output_device: IO_MEDIUM
			-- Input/output media to which all input will be sent and
			-- from which output will be received, respectively

feature {NONE} -- Input

	read_integer
			-- Input an integer (as a sequence of digits terminated with
			-- a newline) and place the result in `last_integer'.  If
			-- any non-digits are included in the input or the input
			-- is empty, last_integer is set to 0.
		do
			read_input_line
			if input_device.last_string.is_integer then
				last_integer := input_device.last_string.to_integer
			else
				last_integer := 0
			end
		end

	read_real
			-- Input a real (as a sequence of characters terminated with
			-- a newline) and place the result in `last_double'.  If the
			-- entered characters do not make up a real value, last_double is
			-- set to 0.
		do
			read_input_line
			if input_device.last_string.is_real then
				last_double := input_device.last_string.to_real
			else
				last_double := 0
			end
		end

	read_line
			-- Input a string and place it in `last_string'.
		do
			read_input_line
			last_string := input_device.last_string
		end

	read_input_line
			-- If `Line_limit' is less than 0 or `current_lines_read' <
			-- `Line_limit', read the next line from `input_device'.
			-- If `Line_limit' is greater than 0 and `current_lines_read' >=
			-- `Line_limit', `current_lines_read' is set to 0 and an
			-- exception is thrown.
		do
			if Line_limit < 0 or else current_lines_read < Line_limit then
				input_device.read_line
			else
				current_lines_read := 0
				raise (Line_limit_reached)
			end
			current_lines_read := current_lines_read + 1
		end

feature {NONE} -- Miscellaneous

	print_message (msg: STRING)
			-- Print `msg' to standard out, appending a newline.
		do
			print_list (<<msg, "%N">>)
		end

	do_choice (descr: STRING; choices: LIST [PAIR [STRING, BOOLEAN]];
				allowed_selections: INTEGER)
			-- Implementation, needed by some children, of procedure for
			-- obtaining a desired list of selections from the user -
			-- resulting in the right member of each pair in `choices'
			-- set to True and the right member of all other pairs
			-- set to False.
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

	last_double: DOUBLE
			-- Last real input with `read_real'

	last_string: STRING
			-- Last string input with `read_line'

	Line_limit: INTEGER
			-- Maximum number of lines that will be read - until
			-- current_lines_read is reset to 0 - before a
			-- `Line_limit_reached' exception is thrown - A value
			-- less than 0 signifies no limit.
		do
			-- Redefine to -1 for no line limit.
			Result := 1000
		end

	Line_limit_reached: STRING = "Input line limit reached"
			-- Name of line-limit-reached exception

	current_lines_read: INTEGER
			-- Current number of lines read in one input attempt

	print (o: ANY)
			-- Redefinition of output method inherited from GENERAL to
			-- send output to output_device
		do
			if o /= Void then
				output_device.put_string (o.out)
			end
		end

	eom: STRING
			-- End-of-message string - redefine if needed
		once
			Result := ""
		end

	input_not_readable_error_message: STRING
		do
			Result := "Input"
			if
				input_device /= Void and then
				input_device.name /= Void and then
				not input_device.name.is_empty
			then
				Result := Result + " " + input_device.name
			end
			Result := Result + " is not readable."
		end

invariant

	Line_limit >= 0 implies current_lines_read <= Line_limit

end
