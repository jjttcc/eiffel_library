indexing

	description:
		"An input sequence that supports bilinear iteration";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

deferred class ITERABLE_INPUT_SEQUENCE inherit

	INPUT_SEQUENCE

	BILINEAR [CHARACTER]
		export {NONE}
			has, index_of, search, occurrences, linear_representation, item
		end

end -- class INPUT_SEQUENCE
