indexing

	description:
		"An input sequence that supports bilinear iteration";
	status: "Copyright 1999 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class ITERABLE_INPUT_SEQUENCE inherit

	INPUT_SEQUENCE

	BILINEAR [CHARACTER]
		export {NONE}
			has, index_of, search, occurrences, linear_representation, item
		end

end -- class INPUT_SEQUENCE
