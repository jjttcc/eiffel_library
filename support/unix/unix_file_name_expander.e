indexing
	description: "Abstraction that provides file name expansion"
	status: "Copyright 1998 - 2000: Jim Cochrane and others -%
		%see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class FILE_NAME_EXPANDER inherit

creation

	make

feature -- Initialization

	make (args: LINKED_LIST [STRING]; option_sign: CHARACTER_REF) is
			-- Expand all arguments that to not start with `option_sign'
			-- and remove each expanded argument from `args'.
		require
			args /= Void
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
		ensure
			names_in_results: results /= Void
		end

feature -- Access

	results: LIST [STRING]
			-- Expanded file names

end -- class FILE_NAME_EXPANDER
