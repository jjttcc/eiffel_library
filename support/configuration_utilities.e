indexing
	description:
		"Utilities for system configuration based parsing a configuration file"
	author: "Jim Cochrane and Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Eirik Mangseth and Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class CONFIGURATION_UTILITIES inherit

feature -- Initialization

	make is
			-- Initialize settings from configuration file.
			-- If an error occurs reading the file, all query values
			-- will be empty strings.
		do
			initialize_settings_table
			process_configuration_file
		end

feature {NONE} -- Implementation - Hook routines

	initialize_settings_table is
			-- Initialize the `settings' table
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

	configuration_file_name: STRING is
		deferred
		end

	check_results is
			-- Check if all needed fields were set and make any needed
			-- settings adjustments.
		deferred
		end

	handle_file_read_error is
			-- Handle failure to read the configuration file - defaults
			-- to throwing and exception - redefine if needed.
		local
			gs: expanded EXCEPTION_SERVICES
			ex: expanded EXCEPTIONS
		do
			gs.last_exception_status.set_fatal (true)
			ex.raise ("Fatal error reading " + configuration_type +
				" configuration file")
		end

	log_errors (errors: ARRAY [ANY]) is
			-- Log `errors' onto a stream appropriate for the application
		deferred
		end

	use_customized_setting (key_token, value_token: STRING): BOOLEAN is
			-- Should the customized configuration setting procedure
			-- `do_customized_setting' be used, rather than the default one
			-- [settings.replace (`value_token', `key_token')]?
		require
			key_exists: key_token /= Void
		once
			-- Default to always true - redefine if needed.
			Result := True
		end

	do_customized_setting (key_token, value_token: STRING) is
			-- Customized configuration setting procedure, to be used
			-- when `default_setting' evaluates to true
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

	settings: HASH_TABLE [STRING, STRING]

	current_line: INTEGER

	su: expanded STRING_UTILITIES

	current_tokens (file_reader: FILE_READER): LIST [STRING] is
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
			file_reader: FILE_READER
			key_token, value_token: STRING
		do
			create file_reader.make (configuration_file_name)
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
						tokens := current_tokens (file_reader)
						key_token := tokens @ key_index
						value_token := tokens @ value_index
						if tokens.count >= 2 then
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
				log_errors (<<"Error reading ", configuration_type,
					" configuration file: ", file_reader.error_string, "%N">>)
				handle_file_read_error
			end
			check_results
		end

feature {NONE} -- Implementation - utilities

	replace_token_all (target, token, new_value: STRING;
		start_delimiter, end_delimiter: CHARACTER) is
			-- Replace in `target' all occurrences of
			-- `start_delimiter' + `token' + `end_delimiter'
			-- with `new_value'.
		local
			replacement: STRING
		do
			replacement := clone (token)
			replacement.prepend_character (start_delimiter)
			replacement.append_character (end_delimiter)
			target.replace_substring_all (replacement, new_value)
		end

invariant

	settings_initialized: settings /= Void

end
