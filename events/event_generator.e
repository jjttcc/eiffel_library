indexing
	description:
		"Objects that generate a list of market events, based on specified %
		%conditions"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

deferred class EVENT_GENERATOR inherit

	FACTORY

feature -- Access

	product: CHAIN [EVENT]

end -- class EVENT_GENERATOR
