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
		require
			exec_precondition: execute_precondition
		deferred
		ensure
			exec_postcondition: execute_postcondition
		end

feature -- Access

	product: ANY is
			-- The object manufactured by calling execute
		deferred
		end

feature -- Status report

	execute_precondition: BOOLEAN is
			-- Precondition for execute function
		do
			Result := true
		ensure
			Result = true
		end

	execute_postcondition: BOOLEAN is
			-- Postcondition for execute function
		do
			Result := true
		ensure
			Result = true
		end

end -- class FACTORY
