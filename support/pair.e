note
	description: "Pairs of objects"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class

	PAIR [G, H]

inherit

	ANY
		redefine
			out
		end

creation

	make

feature -- Initialization

	make (l: G; r: H)
		do
			first := l
			second := r
		ensure
			set: first = l and second = r
		end

feature -- Access

	first: G
			-- First element of the pair

	second: H
			-- Second element of the pair

	left: G
			-- Left element of the pair - synonym for `first'
		do
			Result := first
		end

	right: H
			-- Right element of the pair - synonym for `second'
		do
			Result := second
		end

	out: STRING
			-- Printable representation
		local
			f, s: STRING
		do
			if first = Void then
				f := "-void-"
			else
				f := first.out
			end
			if second = Void then
				s := "-void-"
			else
				s := second.out
			end
			Result := "(" + f + ", " + s + ")"
		end

feature -- Element change

	set_first, set_left (arg: G)
			-- Set `first' (`left') to `arg'.
		do
			first := arg
		ensure
			first_set: first = arg
		end

	set_second, set_right (arg: H)
			-- Set `second' (`right') to `arg'.
		do
			second := arg
		ensure
			second_set: second = arg
		end

invariant

	left_is_synonym_for_first: left = first
	right_is_synonym_for_second: right = second

end -- class PAIR
