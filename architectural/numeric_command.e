indexing
	description: "Command whose result is a numeric value";
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class NUMERIC_COMMAND inherit

	RESULT_COMMAND [REAL]

	MATH_CONSTANTS
		export {NONE}
			all
		end

end -- class NUMERIC_COMMAND
