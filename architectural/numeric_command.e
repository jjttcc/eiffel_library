indexing
	description: "Commands with a numeric value as a result";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class NUMERIC_COMMAND inherit

	RESULT_COMMAND [REAL]

	MATH_CONSTANTS
		export {NONE}
			all
		end

end -- class NUMERIC_COMMAND
