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
		redefine
			initialize, children
		end

	STATE_SET
		rename
			status as state_set_status, item as state_at
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make (i: INDEXED) is
		do
			indexable := i
		ensure
			indexable_set: indexable = i
			not_initialized: not initialized
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

	initialize (arg: ANY) is
		local
			cmd: COMMAND
		do
			-- Prevent infinite recursion if there a cycle - if one of
			-- indexable's descendants is Current.  (INDEX_EXTRACTOR 
			-- tends to be used such that it causes a cycle.)
			if not initialized then
				set_initialized (True)
				cmd ?= indexable
				if cmd /= Void then
					cmd.initialize (arg)
				end
				set_initialized (False)
			end
		end

feature -- Access

	indexable: INDEXED

	children: LIST [COMMAND] is
		local
			cmd: COMMAND
		do
			create {LINKED_LIST [COMMAND]} Result.make
			cmd ?= indexable
			if cmd /= Void then
				Result.extend (cmd)
			end
		end

feature -- Status report

	arg_mandatory: BOOLEAN is
		do
			Result := False
		end

feature -- Basic operations

	execute (arg: ANY) is
		do
			-- @@ Check if indexable.execute should be called here - Since
			-- the indexable's index is being used instead of its value,
			-- it may not be necessary to execute the indexable (and it
			-- could even cause problems: e.g., if the indexable is shared,
			-- it would be executed twice, which could cause unwanted side
			-- effects.  On the other hand, sometimes the value of
			-- indexable may depend for its correctness on execute being
			-- called first.  (This circumstance seems unusual, but not
			-- extremely so.)  Investigate further.
			value := indexable.index
		end

feature {NONE} -- Implementation

	initialized: BOOLEAN is
			-- Implementation state to prevent infinite initialization cycle
		do
			Result := state_at (Initialized_state_index)
		end

	set_initialized (arg: BOOLEAN) is
			-- Set `initialized' according to `arg'.
		require
			arg_not_void: arg /= Void
		do
			put (arg, Initialized_state_index)
		ensure
			initialized_set: initialized = arg and initialized /= Void
		end

feature {NONE} -- Implementation - constants

	Initialized_state_index: INTEGER is 1

end -- class INDEX_EXTRACTOR
