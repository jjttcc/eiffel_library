indexing
	description: "Command with a result of generic type G";
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class RESULT_COMMAND [G] inherit

	COMMAND

feature -- Access

	value: G
			-- The result of execution

end -- class RESULT_COMMAND
