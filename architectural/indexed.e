indexing
	description: "Simple Abstract Data Type with an index feature"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class 

	INDEXED

feature -- Access

	index: INTEGER is
		deferred
		end

invariant

	index_not_negative: index >= 0

end -- class INDEXED
