indexing
	description: "A pair of objects"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class

	PAIR [X, H]

creation

	make

feature -- Initialization

	make (l: G; r: H) is
		require
			not_void: l /= Void and r /= Void
		do
			left := l
			right := r
		ensure
			set: left = l and right = r
		end

feature -- Access

	left: G
		-- Left element of the pair

	right: H
		-- Right element of the pair

feature -- Element change

	set_left (arg: G) is
			-- Set left to `arg'.
		require
			arg_not_void: arg /= Void
		do
			left := arg
		ensure
			left_set: left = arg and left /= Void
		end

	set_right (arg: H) is
			-- Set right to `arg'.
		require
			arg_not_void: arg /= Void
		do
			right := arg
		ensure
			right_set: right = arg and right /= Void
		end

end -- class PAIR
