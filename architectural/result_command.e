indexing
	description: "Commands with a result of generic type G";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class RESULT_COMMAND [G] inherit

	COMMAND
		redefine
			status_contents
		end

feature -- Access

	value: G
			-- The result of execution

feature {NONE} -- Implementation - Hook routine implementations

	status_contents: STRING is
		do
			Result := "value: " + value.out
		end

end -- class RESULT_COMMAND
