indexing
	description: "Abstraction that provides file name expansion"
	status: "Copyright 1998 - 2000: Jim Cochrane and others -%
		%see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class FILE_NAME_EXPANDER inherit

creation

	make

feature -- Initialization

	make (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF) is
			-- Expand all arguments that to not start with `option_sign'
			-- and remove each expanded argument from `args'.
		require
			args /= Void
		do
			from
				create {LINKED_LIST [STRING]} results.make
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
		ensure
			names_in_results: results /= Void
		end

	expand_file_names (s: STRING) is
		local
			e : MAS_EXECUTION_ENVIRONMENT
			b : STRING
			c : STRING
		do
			!!e
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
			!!f.make(markets_file)
			if f.exists then
				f.open_read
				from
					f.start
				until
					f.end_of_file
				loop
					f.read_line
					if not f.end_of_file then
						results.extend(clone(f.last_string))
					end
				end
				f.close
			end
		end

		markets_file: STRING is
			"markets.mas"

		dir_cmd: STRING is
			" /C DIR /B "
				
		pipe: STRING IS 
			" > "


feature -- Access

	results: LIST [STRING]
			-- Expanded file names

end -- class FILE_NAME_EXPANDER
