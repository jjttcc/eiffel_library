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
			create contents.make
			from
				i := 1
			until
				i = argument_count + 1
			loop
				contents.extend (argument (i))
				i := i + 1
			end
			set_help
			set_version_request
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

feature -- Basic operations

	print_usage is
			-- Print `usage' message.
		do
			print (usage)
		end

	usage: STRING is
			-- Message: how to invoke the program from the command-line
		deferred
		end

feature {NONE} -- Implementation

	contents: LINKED_LIST [STRING]

	Help_character: CHARACTER is
		once
			Result := 'h'
		end

	Question_mark: CHARACTER is '?'

	set_help is
		do
			if option_in_contents (Help_character) then
				help := True
				contents.remove
			elseif
				Help_character /= Question_mark and
				option_in_contents (Question_mark)
			then
					help := True
					contents.remove
			end
		end

	set_version_request is
		do
			if option_in_contents ('v') then
				version_request := True
				contents.remove
			end
		end

	set_debug is
			-- Set `is_debug' to True and remove the item that contains
			-- the debug setting from `contents' iff `contents' contains
			-- "-" + Debug_string or "--" + Debug_string.  Descendant must
			-- explicitly call this routine if the debugging state is desired.
		local
			i: INTEGER
		do
			if option_in_contents (Debug_string @ 1) then
				if
					contents.item.substring_index ("-" + Debug_string, 1) = 1
					or
					contents.item.substring_index ("--" + Debug_string, 1) = 1
				then
					is_debug := True
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
				(contents.item.item (1) = option_sign and
				contents.item.item (2) = c) or (contents.item.item (1) =
				option_sign and contents.item.item (2) = option_sign and
				contents.item.item (3) = c))
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

feature {NONE} -- Implementation - Constants

	Debug_string: STRING is "debug"

invariant

end -- class COMMAND_LINE
