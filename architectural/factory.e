indexing
	description:
		"Basic abstraction for a factory that produces a result by %
		%calling execute"
	date: "$Date$";
	revision: "$Revision$"

deferred class FACTORY inherit

	COMMAND

feature -- Basic operations

	execute (arg: ANY) is
			-- Produce a result, stored in `product'.
		deferred
		ensure then
			product /= Void
		end

feature -- Access

	product: ANY is
			-- The object manufactured by calling execute
		deferred
		end

feature -- Status report

end -- class FACTORY
