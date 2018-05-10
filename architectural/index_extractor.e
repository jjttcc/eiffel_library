note
	description:
		"RESULT_COMMANDs that extract the current index from an %
		%INDEXED object"
	note1: "indexable must be attached to a non-void object before execute %
		%is called."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class INDEX_EXTRACTOR inherit

	RESULT_COMMAND [DOUBLE]
		redefine
			initialize, children, descendants_locked, lock_descendants,
			unlock_descendants, suppliers_locked, lock_suppliers,
			unlock_suppliers
		end

	STATE_SET
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make (i: INDEXED)
		do
			indexable := i
		ensure
			indexable_set: indexable = i
			not_initialized: not initialized
		end

	set_indexable (ind: INDEXED)
			-- Set `indexable' to `ind'.
		require
			arg_not_void: ind /= Void
		local
			indcmd: COMMAND
		do
			indexable := ind
			indcmd ?= indexable
			if indcmd /= Void then
				indcmd.initialize_from_parent(Current)
			end
		ensure
			indexable_set: indexable = ind and indexable /= Void
		end

	initialize (arg: ANY)
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

	children: LIST [COMMAND]
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

	arg_mandatory: BOOLEAN
		do
			Result := False
		end

feature -- Basic operations

	execute (arg: ANY)
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

feature {NONE} -- Hook routine implementation
-- Since INDEX_EXTRACTORs are "allowed" to be part of a cycle, these hook
-- routine definitions are needed to prevent infinite "recursive" calls
-- in 'suppliers', 'descendants', ...

	descendants_locked: BOOLEAN
		do
			Result := state_at (Descendants_locked_index)
		end

	lock_descendants
		do
			put_state (True, Descendants_locked_index)
		end

	unlock_descendants
		do
			put_state (False, Descendants_locked_index)
		end

	suppliers_locked: BOOLEAN
		do
			Result := state_at (Suppliers_locked_index)
		end

	lock_suppliers
		do
			put_state (True, Suppliers_locked_index)
		end

	unlock_suppliers
		do
			put_state (False, Suppliers_locked_index)
		end

feature {NONE} -- Implementation

	initialized: BOOLEAN
			-- Implementation state to prevent infinite initialization cycle
		do
			Result := state_at (Initialized_state_index)
		end

	set_initialized (arg: BOOLEAN)
			-- Set `initialized' according to `arg'.
		do
			put_state (arg, Initialized_state_index)
		ensure
			initialized_set: initialized = arg
		end

feature {NONE} -- Implementation - constants
-- These "constants" are implemented as a routine instead of a constant
-- to prevent the "persistent-object-incompatibility" problem when a
-- constant is added or removed.

	Initialized_state_index: INTEGER
		do
			Result := 1
		end

	Descendants_locked_index: INTEGER
		do
			Result := 2
		end

	Suppliers_locked_index: INTEGER
		do
			Result := 3
		end

end -- class INDEX_EXTRACTOR
