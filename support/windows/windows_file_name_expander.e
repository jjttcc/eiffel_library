indexing
	description: "File name expansion for Windows systems"
	author: "Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Eirik Mangseth and Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class WINDOWS_FILE_NAME_EXPANDER inherit

	FILE_NAME_EXPANDER

feature -- Basic operations

	execute (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF) is
			-- Expand all arguments that to not start with `option_sign'
			-- and remove each expanded argument from `args'.
		do
			from
				create {ARRAYED_LIST [STRING]} results.make (args.count)
				args.start
			until
				args.exhausted
			loop
				if not (args.item.item (1) = option_sign) then
					if (args.item.has ('*')) then
						--file names haven't been expanded, do it
						-- "manually". MSWindows specific.
						expand_file_names(args.item)
						read_file_names
						args.remove
					else
						results.extend (args.item)
						args.remove
					end
				else
					args.forth
				end
			end
		end

feature {NONE} -- Implemetation

	expand_file_names (s: STRING) is
		local
			e : MAS_EXECUTION_ENVIRONMENT
			b : STRING
			c : STRING
		do
			create e
			b := clone(e.get("ComSpec"))
			if b /= Void then
				b.append(dir_cmd)
				b.append(clone(s)); b.append(pipe); b.append(markets_file)
				e.system(b)
			end
		end

	read_file_names is
		local
			f: PLAIN_TEXT_FILE
		do
			create f.make(markets_file)
			if f.exists then
				f.open_read
				from
					f.start
				until
					f.end_of_file
				loop
					f.read_line
					if not f.end_of_file then
						results.extend (clone (f.last_string))
					end
				end
				f.close
			end
		end

	markets_file: STRING is "markets.mas"

	dir_cmd: STRING is " /C DIR /B "

	pipe: STRING IS " > "

end -- class WINDOWS_FILE_NAME_EXPANDER
