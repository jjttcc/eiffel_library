note
	description: "A (container of a) single object"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

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
