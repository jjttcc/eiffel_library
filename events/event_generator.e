note
	description:
		"Objects that generate a list of events, based on specified %
		%conditions"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class EVENT_GENERATOR inherit

	GENERIC_FACTORY [CHAIN[EVENT]]

feature -- Access

	product: CHAIN [EVENT]

end -- class EVENT_GENERATOR
