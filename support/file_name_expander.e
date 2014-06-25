note
	description: "File name expansion"
	author: "Eirik Mangseth"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

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
