indexing
	description:
		"RESULT_COMMANDs that extract the current index from an %
		%INDEXED object"
	note: "indexable must be attached to a non-void object before execute %
		%is called."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class INDEX_EXTRACTOR inherit

	RESULT_COMMAND [REAL]

creation

	make

feature -- Initialization

	make (i: INDEXED) is
		do
			indexable := i
		ensure
			indexable_set: indexable = i
		end

	set_indexable (arg: INDEXED) is
			-- Set `indexable' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			indexable := arg
		ensure
			indexable_set: indexable = arg and indexable /= Void
		end

feature -- Access

	indexable: INDEXED

feature -- Status report

	arg_mandatory: BOOLEAN is
		do
			Result := False
		end

feature -- Basic operations

	execute (arg: ANY) is
		do
			value := indexable.index
		end

end -- class INDEX_EXTRACTOR
