note
	description:
		"Basic abstraction for factories that produce a (generically-typed) %
		% result by calling execute"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	GENERIC_FACTORY [G]

inherit

	FACTORY

feature -- Access

	product: G
			-- The object manufactured by calling execute
		deferred
		end

end -- class GENERIC_FACTORY
