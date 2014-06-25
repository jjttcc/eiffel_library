note
	description: "Objects with an index feature"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class 

	INDEXED

feature -- Access

	index: INTEGER
		deferred
		end

invariant

	index_not_negative: index >= 0

end -- class INDEXED
