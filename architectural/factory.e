note
	description:
		"Basic abstraction for factories that produce a result by %
		%calling execute"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class

	FACTORY

feature -- Access

	product: ANY
			-- The object manufactured by calling execute
		deferred
		end

feature -- Status report

	execute_precondition: BOOLEAN
			-- Precondition for `execute'
		do
			-- Satisfied by all states - redefine if a stronger precondition
			-- is needed.
			Result := True
		end

feature -- Basic operations

	execute
			-- Produce a result, stored in `product'.
		require
			execute_precondition: execute_precondition
		deferred
		ensure then
			product_not_void: product /= Void
		end

end -- class FACTORY
