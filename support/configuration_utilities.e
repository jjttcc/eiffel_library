indexing
	description: "Utilities for system configuration based on parsing a %
		%configuration file"
	author: "Jim Cochrane and Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Eirik Mangseth and Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class CONFIGURATION_UTILITIES inherit

	GENERAL_UTILITIES
		export
			{NONE} all
		end

feature -- Initialization

	make is
			-- Initialize settings from configuration file.
			-- If an error occurs reading the file, all query values
			-- will be empty strings.
		do
			file_reader := new_file_reader
			initialize
			process_configuration_file
		end

feature {NONE} -- Implementation - Hook routines

	initialize is
			-- Initialize the `settings' table and any other items needing
			-- initialization.
		deferred
		ensure
			settings_created: settings /= Void
		end

	configuration_type: STRING is
			-- The type of configuration - e.g., "database" configuration
		deferred
		end

	comment_character: CHARACTER is
			-- The character that, when at the beginning of a "line",
			-- indicates that the "line" is a comment
		deferred
		end

	key_index: INTEGER is
			-- Index of the settings key within the current record
		deferred
		end

	value_index: INTEGER is
			-- Index of the settings value within the current record
		deferred
		end

	new_file_reader: FILE_READER is
		deferred
		end

	post_process_settings is
			-- Do any needed post-processing of the settings after
			-- the configuration file has been read and processed.
		do
			-- Null procedure - redefine if needed
		end

	check_results is
			-- Check if all needed fields were set and make any needed
			-- settings adjustments.
		deferred
		end

	handle_file_read_error (msg: STRING) is
			-- Handle failure to read the configuration file - defaults
			-- to throwing and exception - redefine if needed.
		require
			msg_exists: msg /= Void
		local
			gs: expanded EXCEPTION_SERVICES
			ex: expanded EXCEPTIONS
		do
			gs.last_exception_status.set_fatal (true)
			ex.raise (msg)
		end

	use_customized_setting (key, value: STRING): BOOLEAN is
			-- Should the customized configuration setting procedure
			-- `do_customized_setting' be used, rather than the default one
			-- [settings.replace (`value', `key')]?
		require
			args_exist: key/= Void and value /= Void
		once
			-- Default to always False - redefine if needed.
			Result := False
		end

	do_customized_setting (key, value: STRING) is
			-- Customized configuration setting procedure, to be used
			-- when `default_setting' evaluates to true
		require
			args_exist: key/= Void and value /= Void
		do
			-- Default to null procedure - redefine if needed.
		end

feature {NONE} -- Implementation

	field_separator: STRING is
			-- Field separator - redefine if needed
		once
			Result := "%T"
		end

	Record_separator: STRING is
			-- Record separator - redefine if needed
		once
			Result := "%N"
		end

	Continuation_character: CHARACTER is
			-- Character that indicates continuation onto next "line"
		once
			Result := '\'
		end

	current_tokens: LIST [STRING] is
			-- Tokens for the current "line" of `file_reader'
		local
			s: STRING
		do
			from
				s := file_reader.item
			until
				s.item (s.count) /= Continuation_character or
				file_reader.exhausted
			loop
				file_reader.forth
				current_line := current_line + 1
				if not file_reader.exhausted then
					s.append (file_reader.item)
				end
			end
			s.prune_all (Continuation_character)
			su.set_target (s)
			Result := su.tokens (Field_separator)
		end

	process_configuration_file is
		local
			tokens: LIST [STRING]
			key_token, value_token, errmsg: STRING
		do
			file_reader.tokenize (Record_separator)
			if not file_reader.error then
				from
					current_line := 1
				until
					file_reader.exhausted
				loop
					if
						not (file_reader.item.count = 0 or else
							file_reader.item @ 1 = comment_character)
					then
						tokens := current_tokens
						if tokens.count >= 2 then
							key_token := tokens @ key_index
							value_token := tokens @ value_index
							if
								use_customized_setting (key_token, value_token)
							then
								do_customized_setting (key_token, value_token)
							else
								settings.replace (value_token, key_token)
							end
							if settings.not_found then
								log_errors (<<"Invalid identifier in ",
									configuration_type, " configuration file",
									" at line ", current_line, ": ",
									key_token, ".%N">>)
							end
						else
							log_errors (<<"Wrong number of fields in ",
									configuration_type, " configuration file",
									" at line ", current_line, ": ",
									file_reader.item, ".%N">>)
						end
					end
					file_reader.forth
					current_line := current_line + 1
				end
			else
				errmsg := "Fatal error reading " + configuration_type +
					" configuration file:%N" + file_reader.error_string + "%N"
				log_error (errmsg)
				handle_file_read_error (errmsg)
			end
			post_process_settings
			check_results
		end

	check_for_missing_specs (ftbl: ARRAY[ANY]; ignore_if_all_true: BOOLEAN) is
			-- Check for missing field specs in `ftbl'.   If
			-- `ignore_if_all_true' and all 'missing' flags in ftl are
			-- True, do not consider it an error.  Expected
			-- types of ftbl's contents are: <<BOOLEAN, STRING,
			-- BOOLEAN, STRING, ...>>, where the BOOLEAN element indicates
			-- that the corresponding field is missing and the STRING
			-- element gives the name of the corresponding field.
		require
			count_even: ftbl.count \\ 2 = 0
		local
			s: STRING
			i: INTEGER
			missing: BOOLEAN_REF
			all_missing, problem: BOOLEAN
			es: expanded EXCEPTION_SERVICES
			ex: expanded EXCEPTIONS
		do
			from i := 1; all_missing := True until i > ftbl.count loop
				missing ?= ftbl @ i
				check
					correct_type: missing /= Void
				end
				if missing.item then
					s := concatenation (<<s, "Missing specification in ",
						configuration_type, " configuration file:%N",
						ftbl @ (i+1), ".%N">>)
					problem := True
				else
					all_missing := False
				end
				i := i + 2
			end
			if problem and (ignore_if_all_true implies not all_missing) then
				log_error (s)
				es.last_exception_status.set_fatal (True)
				ex.raise ("Fatal error reading " + configuration_type +
					" configuration file")
			end
		end

feature {NONE} -- Implementation - attributes

	settings: HASH_TABLE [STRING, STRING]

	current_line: INTEGER

	su: expanded STRING_UTILITIES

	file_reader: FILE_READER

invariant

	settings_initialized: settings /= Void
	file_reader_initialized: file_reader /= Void

end
