indexing
	description:
		"Basic abstraction for factories that produce a result by %
		%calling execute"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	FACTORY

feature -- Basic operations

	execute is
			-- Produce a result, stored in `product'.
		deferred
		ensure then
			product_not_void: product /= Void
		end

feature -- Access

	product: ANY is
			-- The object manufactured by calling execute
		deferred
		end

end -- class FACTORY
