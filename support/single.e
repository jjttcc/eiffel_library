note
	description: "A (container of a) single object"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	SINGLE [G]

creation

	make, make_item

feature -- Initialization

	make
		do
		end

	make_item (o: G)
		do
			item := o
		ensure
			set: item = o
		end

feature -- Access

	item: G
		-- The single item

feature -- Element change

	set_item (arg: G)
			-- Set `item' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			item := arg
		ensure
			item_set: item = arg and item /= Void
		end

end -- class SINGLE
