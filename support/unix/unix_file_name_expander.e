note
	description: "File name expansion for UNIX systems"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class UNIX_FILE_NAME_EXPANDER inherit

	FILE_NAME_EXPANDER

feature -- Basic operations

	execute (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF)
		do
			from
				create {LINKED_LIST [STRING]} results.make
				args.start
			until
				args.exhausted
			loop
				if not (args.item.item (1) = option_sign) then
					results.append (expanded_names (args.item))
					args.remove
				else
					args.forth
				end
			end
		end

feature {NONE} -- Implemention

	expanded_names (expr: STRING): LIST [STRING]
		local
			process: EPX_EXEC_PROCESS
			output: POSIX_FILE_DESCRIPTOR
			env: expanded EXECUTION_ENVIRONMENT
			shell: STRING
		do
			if contains_meta_characters (expr) then
				if env.default_shell = Void then
					shell := Default_default_shell
				else
					shell := env.default_shell
				end
				check
					shell_exists: shell /= Void
				end
				create process.make_capture_output (shell,
					Expansion_command (expr))
				process.execute
				output := process.fd_stdout
				if output.is_open and not output.end_of_input then
					output.read_line
					output.last_string.right_adjust
					Result := output.last_string.split (' ')
				else
					create {LINKED_LIST [STRING]} Result.make
				end
			else
				create {LINKED_LIST [STRING]} Result.make
				Result.extend (expr)
			end
		end

	contains_meta_characters (expr: STRING): BOOLEAN
			-- Does `expr' contain any shell metacharacters
		local
			i: INTEGER
			s: STRING
		do
			from
				i := 1
				s := Shell_meta_characters
			until
				Result or i > s.count
			loop
				if expr.has (s @ i) then
					Result := True
				end
				i := i + 1
			end
		end

	Max_output_length: INTEGER = 5000000

	Default_default_shell: STRING = "/bin/sh"

	Expansion_command (expr: STRING): ARRAY [STRING]
		do
			Result := <<"-c", "echo " + expr>>
		ensure
			arg_exists: Result /= Void
		end

	Shell_meta_characters: STRING = "[?*"

end -- class UNIX_FILE_NAME_EXPANDER
