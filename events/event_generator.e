indexing
	description:
		"Objects that generate a list of market events, based on specified %
		%conditions"
	status: "Copyright 1998 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class EVENT_GENERATOR inherit

	FACTORY

feature -- Access

	product: CHAIN [EVENT]

end -- class EVENT_GENERATOR
