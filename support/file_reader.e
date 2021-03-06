note
	description: "Facilities for reading and tokenizing a text file"
	author: "Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class FILE_READER inherit

	GENERAL_UTILITIES
		export
			{NONE} all
			{ANY} deep_twin, is_deep_equal, standard_is_equal
		end

creation

	make

feature

	make (file_name: STRING)
		require
			file_name /= Void
		do
			create target.make (file_name)
		end

feature -- Access

	item: STRING
			-- Current field

	contents: STRING
			-- Contents of the entire file
		do
			error := False
			if file_contents = Void then
				if
					target.exists and then target.is_readable and then
					not target.is_directory
				then
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

	forth
			-- Move to next field; if no next field,
			-- ensure that exhausted will be True.
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

	tokenize (separator: STRING)
			-- Tokenize the file contents based on `separator'.
		do
			if contents /= Void then
				if separator.is_equal ("%N") then
					-- Tokenizing a file with DOS carriage returns and with
					-- a newline as the separator will not work, so
					-- remove the DOS carriage returns.
					contents.prune_all ('%R')
				end
				su.set_target (contents)
				tokens := su.tokens (separator)
				tokens.start
				item := tokens.item
			end
		end

feature {NONE}

	target: PLAIN_TEXT_FILE

	su: expanded STRING_UTILITIES

	tokens: DYNAMIC_LIST [STRING]

	file_contents: STRING

invariant

end
