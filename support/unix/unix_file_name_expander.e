indexing
	description: "File name expansion for UNIX systems"
	status: "Copyright 1998 - 2000: Jim Cochrane and others -%
		%see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class UNIX_FILE_NAME_EXPANDER inherit

	FILE_NAME_EXPANDER

feature -- Basic operations

	execute (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF) is
		do
			from
				create {LINKED_LIST [STRING]} results.make
				args.start
			until
				args.exhausted
			loop
				if not (args.item.item (1) = option_sign) then
					results.extend (args.item)
					args.remove
				else
					args.forth
				end
			end
		end

end -- class UNIX_FILE_NAME_EXPANDER
