note
	description:
		"Basic abstraction for factories that produce a (generically-typed) %
		% result by calling execute"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

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
