indexing
	description: "Commands with a result of generic type G";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class RESULT_COMMAND [G] inherit

	COMMAND

feature -- Access

	value: G
			-- The result of execution

end -- class RESULT_COMMAND
