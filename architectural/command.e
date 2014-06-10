note
	description: "Basic abstraction for executable commands"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class COMMAND inherit

	TREE_NODE
		redefine
			name, alternate_status_tag, status_contents
		end

feature -- Initialization

	initialize (arg: ANY)
			-- Perform initialization, obtaining any needed values from arg.
			-- Null action by default - descendants redefine as needed.
		require
			arg_not_void: arg /= Void
		do
		end

feature -- Access

	children: LIST [COMMAND]
			-- This command's children, if this is a composite command
		do
			-- Empty by default - redefine if needed.
			create {LINKED_LIST [COMMAND]} Result.make
		end

	suppliers: SET [ANY]
			-- One instance of each supplier class (usually arguments to
			-- `execute', but the precise semantics are at the discretion
			-- of the class's author) used by Current and its `descendants'
			-- to carry out the calculation performed by `execute' -
			-- This feature is intended to allow run-time type checking
			-- that may be needed by some applications.
		local
			l: LIST [COMMAND]
		do
			if not suppliers_locked then
				lock_suppliers -- Prevent following of a cycle.
				l := children
				if not l.is_empty then
					Result := l.first.suppliers
					from
						l.go_i_th (2)
					until
						l.exhausted
					loop
						Result.fill (l.item.suppliers)
						l.forth
					end
				else
					create {LINKED_SET [ANY]} Result.make
				end
				Result.fill (root_suppliers)
				unlock_suppliers
			else
				create {LINKED_SET [ANY]} Result.make
			end
		ensure
			exists: Result /= Void
			same_lock_state: suppliers_locked = old suppliers_locked
		end

	root_suppliers: SET [ANY]
			-- An instance of each supplier class used by Current
			-- (usually arguments to `execute', but the precise semantics
			-- are at the discretion of the class's author), as the
			-- root of a command hierarchy (i.e., exluding suppliers
			-- of `descendants'), to carry out its execution
		do
			-- Default to empty - redefine as needed.
			create {LINKED_SET [ANY]} Result.make
		ensure
			not_void: Result /= Void
		end

	name: STRING
			-- Current's name
		do
			Result := name_implementation
			if Result = Void then
				Result := ""
			end
		end

feature -- Status report

	arg_mandatory: BOOLEAN
			-- Is the argument to execute mandatory?
		deferred
		end

	is_editable: BOOLEAN
			-- Is Current editable - that is, does it have one or more
			-- parameters that can be changed?
		do
			-- Default to False - redefine if needed.
		end

feature -- Element change

	set_name (arg: STRING)
			-- Set `name' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			name_implementation := clone (arg)
		ensure
			name_set: name_implementation.is_equal (arg) and name /= Void
		end

feature -- Basic operations

	execute (arg: ANY)
			-- Execute the command with the specified argument.
		require
			arg_not_void_if_mandatory: arg_mandatory implies arg /= Void
		deferred
		end

	prepare_for_editing (editor: ANY)
			-- Prepare `editor' for editing Current (not Current's children).
		require
			editable: is_editable
			editor_exists: editor /= Void
		do
			-- Default to null action - Redefine if needed.
		end

feature {NONE} -- Implementation

	name_implementation: STRING

feature {NONE} -- Implementation - Hook routines

	suppliers_locked: BOOLEAN
			-- Implementation state to prevent infinite calls to suppliers
			-- when Current is part of a cycle - Redefine appropriately,
			-- along with `lock_suppliers' and `unlock_suppliers',
			-- if this functionality is required.
		do
			Result := False
		end

	lock_suppliers
		do
		end

	unlock_suppliers
		do
		end

feature {NONE} -- Implementation - Hook routine implementations

	alternate_status_tag: STRING
		do
			Result := Current.generator + ": "
		end

	status_contents: STRING
		do
			Result := "[no value]"
		end

invariant

end -- class COMMAND
