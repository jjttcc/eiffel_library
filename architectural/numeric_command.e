indexing
	description: "Command whose result is a numeric value";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

deferred class NUMERIC_COMMAND inherit

	RESULT_COMMAND [REAL]

	MATH_CONSTANTS
		export {NONE}
			all
		end

end -- class NUMERIC_COMMAND
