indexing
	description: "File name expansion for Windows systems"
	author: "Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Eirik Mangseth and Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

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
					-- If a UNIX-style separator was used, convert to Windows.
					args.item.replace_substring_all ("/", "\")
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
			e: expanded EXECUTION_ENVIRONMENT
			o: expanded OPERATING_ENVIRONMENT
			b, file_glob, previous_dir: STRING
			last_sep: INTEGER
		do
			b := clone(e.get("ComSpec"))
			if b /= Void then
				if s.has (o.directory_separator) then
					-- Separate out the directory part of `s', place it
					-- in `working_directory', place the remainder of
					-- `s' into file_glob, and cd to `working_directory'.
					previous_dir := e.current_working_directory
					last_sep := s.last_index_of (o.directory_separator,
						s.count)
					working_directory := s.substring (1, last_sep)
					file_glob := s.substring (last_sep + 1, s.count)
					e.change_working_directory (working_directory)
					work_file.prepend (
						previous_dir + o.directory_separator.out)
				else
					file_glob := s
				end
				b.append(dir_cmd)
				b.append(clone(file_glob))
				b.append(output_redirect)
				b.append(work_file)
				e.system(b)
				if previous_dir /= Void then
					e.change_working_directory (previous_dir)
				end
			end
		end

	read_file_names is
		local
			f: PLAIN_TEXT_FILE
			fname: STRING
		do
			create f.make(work_file)
			if f.exists then
				f.open_read
			end
			if f.readable then
				from
					f.start
				until
					f.end_of_file
				loop
					f.read_line
					if not f.end_of_file then
						fname := clone (f.last_string)
						if working_directory /= Void then
							fname := working_directory + fname
						end
						results.extend (fname)
					end
				end
				f.close
			end
			if f.exists then
				f.delete
			end
		end

	work_file: STRING is "files.mas-tmp-expand"

	working_directory: STRING

	dir_cmd: STRING is " /C DIR /B "

	output_redirect: STRING IS " > "

end
