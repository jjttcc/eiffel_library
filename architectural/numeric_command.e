note
	description: "Commands with a numeric value as a result";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class NUMERIC_COMMAND inherit

	RESULT_COMMAND [DOUBLE]

	MATH_CONSTANTS
		export {NONE}
			all
		end

end -- class NUMERIC_COMMAND
