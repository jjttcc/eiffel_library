indexing
	description: "Command whose result is a numeric value";
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class NUMERIC_COMMAND inherit

	COMMAND

	MATH_CONSTANTS
		export {NONE}
			all
		end

feature -- Access

	value: REAL
			-- The result of execution

end -- class NUMERIC_COMMAND
