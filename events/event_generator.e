indexing
	description:
		"Objects that generate a list of events, based on specified %
		%conditions"
	NOTE: "!!!Consider getting rid of this class and putting its product %
	%redefinition into MARKET_ANALYZER."
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class EVENT_GENERATOR inherit

	FACTORY

feature -- Access

	product: SEQUENCE [EVENT]

end -- class EVENT_GENERATOR
