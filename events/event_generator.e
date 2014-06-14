note
	description:
		"Objects that generate a list of events, based on specified %
		%conditions"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class EVENT_GENERATOR inherit

	FACTORY [CHAIN[EVENT]]

feature -- Access

	product: CHAIN [EVENT]

end -- class EVENT_GENERATOR
