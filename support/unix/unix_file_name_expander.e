indexing
	description: "File name expansion for UNIX systems"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class UNIX_FILE_NAME_EXPANDER inherit

	FILE_NAME_EXPANDER

feature -- Basic operations

	execute (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF) is
		do
			from
				create {ARRAYED_LIST [STRING]} results.make (args.count)
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
