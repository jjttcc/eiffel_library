indexing
	description: "A (container of a) single object"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class

	SINGLE [G]

creation

	make, make_item

feature -- Initialization

	make is
		do
		end

	make_item (o: G) is
		do
			item := o
		ensure
			set: item = o
		end

feature -- Access

	item: G
		-- The single item

feature -- Element change

	set_item (arg: G) is
			-- Set `item' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			item := arg
		ensure
			item_set: item = arg and item /= Void
		end

end -- class SINGLE
