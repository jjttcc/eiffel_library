note

	description:
		"An input sequence that supports bilinear iteration";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class ITERABLE_INPUT_SEQUENCE inherit

	INPUT_SEQUENCE

	BILINEAR [CHARACTER]
		export {NONE}
			has, index_of, search, occurrences, linear_representation, item
		end

end
