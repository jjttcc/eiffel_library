indexing
	description: "File name expansion"
	status: "Copyright 1998 - 2000: Jim Cochrane and others -%
		%see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class FILE_NAME_EXPANDER inherit

feature -- Basic operations

	execute (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF) is
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
