indexing
	description:
		"Basic abstraction for factories that produce a result by %
		%calling execute"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class

	FACTORY

feature -- Access

	product: ANY is
			-- The object manufactured by calling execute
		deferred
		end

feature -- Status report

	execute_precondition: BOOLEAN is
			-- Precondition for `execute'
		do
			-- Satisfied by all states - redefine if a stronger precondition
			-- is needed.
			Result := True
		end

feature -- Basic operations

	execute is
			-- Produce a result, stored in `product'.
		require
			execute_precondition: execute_precondition
		deferred
		ensure then
			product_not_void: product /= Void
		end

end -- class FACTORY
