note
	description: "File name expansion"
	author: "Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Eirik Mangseth and Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class FILE_NAME_EXPANDER inherit

feature -- Basic operations

	execute (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF)
			-- Perform file-name expansion on all members of `args' that
			-- do not begin with `option_sign'.
		require
			not_void: args /= Void and option_sign /= Void
		deferred
		ensure
			names_in_results: results /= Void
		end

feature -- Access

	results: LIST [STRING]
			-- Expanded file names

end -- class FILE_NAME_EXPANDER
