indexing
	description:
		"Basic abstraction for a factory that produces a result by %
		%calling execute"
	date: "$Date$";
	revision: "$Revision$"

deferred class 
	FACTORY

feature -- Basic operations

	execute (arg: ANY) is
			-- Produce a result, stored in `product'.
		deferred
		end

feature -- Access

	product: ANY is
			-- The object manufactured by calling execute
		deferred
		end

end -- class FACTORY
