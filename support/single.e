indexing
	description: "A (container of a) single object"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

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
