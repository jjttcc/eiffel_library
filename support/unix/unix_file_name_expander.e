indexing
	description: "File name expansion for UNIX systems"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class UNIX_FILE_NAME_EXPANDER inherit

	FILE_NAME_EXPANDER

feature -- Basic operations

	execute (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF) is
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

	expanded_names (expr: STRING): LIST [STRING] is
		local
			process: EPX_EXEC_PROCESS
			output: POSIX_FILE_DESCRIPTOR
			env: expanded EXECUTION_ENVIRONMENT
			shell: STRING
		do
			if env.default_shell = Void then
				shell := Default_default_shell
			else
				shell := env.default_shell
			end
			check
				shell_exists: shell /= Void
			end
			create process.make_capture_output (shell, Expansion_command (expr))
			process.execute
			output := process.fd_stdout
			if output.is_open and not output.eof then
				output.read_line (Max_output_length)
				output.last_line.right_adjust
				Result := output.last_line.split (' ')
			else
				create {LINKED_LIST [STRING]} Result.make
			end
		end

	Max_output_length: INTEGER is 5000000

	Default_default_shell: STRING is "/bin/sh"

	Expansion_command (expr: STRING): ARRAY [STRING] is
		do
			Result := <<"-c", "echo " + expr>>
		ensure
			arg_exists: Result /= Void
		end

end -- class UNIX_FILE_NAME_EXPANDER
