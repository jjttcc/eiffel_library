indexing
	description:
		"Generic parser of command-line arguments for an application"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class COMMAND_LINE inherit

	ARGUMENTS
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make is
		local
			i: INTEGER
		do
			error_description := ""
			create contents.make
			from
				i := 1
			until
				i = argument_count + 1
			loop
				contents.extend (argument (i))
				i := i + 1
			end
			check_for_ambiguous_options
			process_arguments (initial_setup_procedures)
			prepare_for_argument_processing
			process_arguments (main_setup_procedures)
			finish_argument_processing
			check_for_invalid_flags
		end

feature -- Access

	help: BOOLEAN
			-- Has the user requested help on command-line options?
			-- True if "-h" or "-?" is found.

	version_request: BOOLEAN
			-- Has the user requested the version number?
			-- True if "-v" is found.

	is_debug: BOOLEAN
			-- Has "debug" mode been specified?

	error_occurred: BOOLEAN
			-- Did an error occur while processing options?

	error_description: STRING
			-- Description of error, if available

	usage: STRING is
			-- Message: how to invoke the program from the command-line
		deferred
		end

feature -- Basic operations

	print_usage is
			-- Print `usage' message.
		do
			print (usage)
		end

	check_for_invalid_flags is
			-- Check for invalid arguments - that is, items in
			-- `contents' that begin with '-' that remain after the valid
			-- arguments have been processed and removed from `contents'.
		require
			error_description_exists: error_description /= Void
		local
			flags: LIST [STRING]
		do
			flags := remaining_flags
			if not flags.is_empty then
				error_occurred := True
				flags.start
				error_description.append ("Invalid option: " + flags.item +
					"%N")
				from
					flags.forth
				until
					flags.exhausted
				loop
					error_description.append ("Invalid option: " + flags.item +
						"%N")
					flags.forth
				end
			end
		end

feature {NONE} -- Implementation - argument processing

	process_arguments (setup_procedures: LINEAR [PROCEDURE [ANY, TUPLE []]]) is
		do
			from
				setup_procedures.start
			until
				setup_procedures.exhausted
			loop
				-- Continue running setup_procedures.item until no more
				-- arguments for that procedure are found.
				from
					last_argument_found := False
					setup_procedures.item.call ([])
				until
					not last_argument_found
				loop
					last_argument_found := False
					setup_procedures.item.call ([])
				end
				setup_procedures.forth
			end
		end

	initial_setup_procedures: LINEAR [PROCEDURE [ANY, TUPLE []]] is
			-- Setup procedures used to process arguments
		local
			a: ARRAY [PROCEDURE [ANY, TUPLE []]]
		do
			a := <<agent set_help, agent set_version_request>>
			Result := a.linear_representation
		end

	last_argument_found: BOOLEAN
			-- Was the last argument processed by a 'setup procedure' found
			-- in the argument list?

feature {NONE} -- Implementation - Hook routines

	prepare_for_argument_processing is
			-- Do any needed preparations before processing arguments.
		deferred
		end

	finish_argument_processing is
			-- Do any needed cleanup after processing arguments.
		deferred
		end

	main_setup_procedures: LINKED_LIST [PROCEDURE [ANY, TUPLE []]] is
			-- Setup procedures used to process arguments
		deferred
		end

	ambiguous_characters: LINEAR [CHARACTER] is
		once
			-- Default to an empty list.
			create {LINKED_LIST [CHARACTER]} Result.make
		end

	handle_ambiguous_option is
			-- Handle the ambiguous option in `contents.item'.
		do
			-- Redefine if different behavior is needed.
			error_occurred := True
			error_description := Ambiguous_option_message + ": %"" +
				contents.item + "%"%N"
		end

feature {NONE} -- Implementation

	contents: LINKED_LIST [STRING]

	help_character: CHARACTER is
		once
			Result := 'h'
		end

	question_mark: CHARACTER is '?'

	set_help is
		do
			if option_in_contents (Help_character) then
				help := True
				last_argument_found := True
				contents.remove
			elseif
				Help_character /= Question_mark and
				option_in_contents (Question_mark)
			then
				help := True
				last_argument_found := True
				contents.remove
			end
		end

	set_version_request is
		do
			if option_in_contents ('v') then
				version_request := True
				last_argument_found := True
				contents.remove
			end
		end

	set_debug is
			-- Set `is_debug' to True and remove the item that contains
			-- the debug setting from `contents' iff `contents' contains
			-- "-" + Debug_string or "--" + Debug_string.  Descendant must
			-- explicitly call this routine if the debugging state is desired.
		do
			if option_in_contents (Debug_string @ 1) then
				if
					contents.item.substring_index ("-" + Debug_string, 1) = 1
					or
					contents.item.substring_index ("--" + Debug_string, 1) = 1
				then
					is_debug := True
					last_argument_found := True
					contents.remove
				end
			end
		end

	option_in_contents (c: CHARACTER): BOOLEAN is
			-- Is option `c' in `contents'?  (If so, position `contents'
			-- cursor to the matching item.)
		do
			from
				contents.start
			until
				contents.exhausted or Result
			loop
				if
					(contents.item.count >= 2 and
					contents.item.item (1) = option_sign and
					contents.item.item (2) = c) or
						-- Allow GNU "--opt" type options:
					(contents.item.count >= 3 and
					contents.item.item (1) = option_sign and
					contents.item.item (2) = option_sign and
					contents.item.item (3) = c)
				then
					Result := True
				else
					contents.forth
				end
			end
		ensure
			cursor_set_if_true: Result = (not contents.exhausted and then
				((contents.item.item (1) = option_sign and
				contents.item.item (2) = c) or (contents.item.item (1) =
				option_sign and contents.item.item (2) = option_sign and
				contents.item.item (3) = c)))
			exhausted_if_false: not Result = contents.exhausted
		end

	option_string_in_contents (s: STRING): BOOLEAN is
			-- Is option `c' in `contents'?
		local
			scount: INTEGER
		do
			from
				scount := s.count
				contents.start
			until
				contents.exhausted or Result
			loop
				if
					(contents.item.count >= scount + 1 and
					contents.item.item (1) = option_sign and
					contents.item.substring (2, scount + 1).is_equal (s)) or
						-- Allow GNU "--opt" type options:
					(contents.item.count >= scount + 2 and
					contents.item.item (1) = option_sign and
					contents.item.item (2) = option_sign and
					contents.item.substring (3, scount + 2).is_equal (s))
				then
					Result := True
				else
					contents.forth
				end
			end
		ensure
			Result implies (contents.item.item (1) = option_sign and
				contents.item.substring (2, s.count + 1).is_equal (s)) or
				(contents.item.item (1) = option_sign and
				contents.item.item (2) = option_sign and
				contents.item.substring (3, s.count + 2).is_equal (s))
		end

	one_character_option (c: CHARACTER): BOOLEAN is
			-- Does `c' occur in `contents' as a one-character option
			-- (e.g., "-x")?
		do
			Result := option_in_contents (c)
			if Result then
				Result := contents.item.is_equal ("-" + c.out) or
					contents.item.is_equal ("--" + c.out)
			end
		end

	check_for_ambiguous_options is
			-- Check for ambiguous options
		do
			from
				ambiguous_characters.start
			until
				ambiguous_characters.exhausted
			loop
				if one_character_option (ambiguous_characters.item) then
					handle_ambiguous_option
					contents.remove
				end
				ambiguous_characters.forth
			end
		end

	remaining_flags: LINKED_LIST [STRING] is
			-- Arguments remaining in `contents' that begin with '-' -
			-- Intended to be used to find invalid arguments after the valid
			-- arguments have been processed and removed from `contents'.
		do
			from
				create Result.make
				contents.start
			until
				contents.exhausted
			loop
				if contents.item @ 1 = '-' then
					Result.extend (contents.item)
				end
				contents.forth
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation - Constants

	debug_string: STRING is
		once
			Result := "debug"
		end

	ambiguous_option_message: STRING is
		once
			Result := "Ambiguous option"
		end

invariant

end -- class COMMAND_LINE
