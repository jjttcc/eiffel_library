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

	error_occurred: BOOLEAN
			-- Did an error occur while processing options?

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

	set_help is
		do
			if option_in_contents ('h') then
				help := true
				contents.remove
			elseif option_in_contents ('?') then
					help := true
					contents.remove
			end
		end

	set_version_request is
		do
			if option_in_contents ('v') then
				version_request := true
				contents.remove
			end
		end

	option_in_contents (c: CHARACTER): BOOLEAN is
			-- Is option `c' in `contents'?
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
					Result := true
				else
					contents.forth
				end
			end
		ensure
			Result implies (contents.item.item (1) = option_sign and
				contents.item.item (2) = c) or (contents.item.item (1) =
				option_sign and contents.item.item (2) = option_sign and
				contents.item.item (3) = c)
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
					Result := true
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

invariant

end -- class COMMAND_LINE
