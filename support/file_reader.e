indexing
	description: "Facilities for reading and tokenizing a text file"
	author: "Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Eirik Mangseth and Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class FILE_READER inherit

	GENERAL_UTILITIES
		export {NONE}
			all
		end

creation

	make

feature

	make (file_name: STRING) is
		require
			file_name /= Void
		do
			create target.make (file_name)
		end

feature -- Access

	item: STRING
			-- Current tokenized field

	contents: STRING is
			-- Contents of the entire file
		do
			error := false
			if file_contents = Void then
				if target.exists and then target.is_readable then
					target.open_read
					if not target.is_empty then
						target.read_stream (target.count)
						file_contents := target.last_string
					else
						file_contents := ""
					end
				else
					if not target.exists then
						error_string := concatenation (<<"File ", target.name,
							" does not exist.">>)
						error := True
					else
						error_string := concatenation (<<"File ", target.name,
							" is not readable.">>)
						error := True
					end
				end
			end
			Result := file_contents
		ensure
			void_if_error: error implies Result = Void
		end

	error_string: STRING
			-- Description of last error

feature -- Status report

	error: BOOLEAN
			-- Did an error occur while reading the input file?

	exhausted: BOOLEAN
			-- Has structure been completely explored?

feature -- Cursor movement

	forth is
			-- Move to next field; if no next field,
			-- ensure that exhausted will be true.
		do
			tokens.forth
			if not tokens.exhausted then
				item := tokens.item
			else
				exhausted := True
				item := Void
			end
		ensure
			item_void_if_exhausted: exhausted implies item = Void
		end

feature -- Basic operations

	tokenize (field_separator: STRING) is
			-- Tokenize the file contents based on `field_separator'.
		do
			if contents /= Void then
				if field_separator.is_equal ("%N") then
					-- Tokenizing a file with DOS carriage returns and with
					-- a newline as the field separator will not work, so
					-- remove the DOS carriage returns.
					contents.prune_all ('%R')
				end
				su.set_target (contents)
				tokens := su.tokens (field_separator)
				tokens.start
				item := tokens.item
			end
		end

feature {NONE}

	target: PLAIN_TEXT_FILE

	su: expanded STRING_UTILITIES

	tokens: LIST [STRING]

	file_contents: STRING

end
