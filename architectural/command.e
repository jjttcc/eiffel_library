indexing
	description: "Basic abstraction for executable commands"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class COMMAND inherit

	TREE_NODE
		redefine
			name, alternate_status_tag, status_contents
		end

feature -- Initialization

	initialize (arg: ANY) is
			-- Perform initialization, obtaining any needed values from arg.
			-- Null action by default - descendants redefine as needed.
		require
			arg_not_void: arg /= Void
		do
		end

feature -- Access

	children: LIST [COMMAND] is
			-- This command's children, if this is a composite command
		do
			-- Empty by default - redefine if needed.
			create {LINKED_LIST [COMMAND]} Result.make
		end

	suppliers: SET [ANY] is
			-- One instance of each supplier class (usually arguments to
			-- `execute', but the precise semantics are at the discretion
			-- of the class's author) used by Current and its `descendants'
			-- to carry out the calculation performed by `execute' -
			-- This feature is intended to allow run-time type checking
			-- that may be needed by some applications.
		local
			l: LIST [COMMAND]
		do
			l := descendants
			if not l.is_empty then
				Result := descendants.first.suppliers
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
		end

	root_suppliers: SET [ANY] is
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

	name: STRING is
			-- Current's name
		do
			Result := name_implementation
			if Result = Void then
				Result := ""
			end
		end

feature -- Status report

	arg_mandatory: BOOLEAN is
			-- Is the argument to execute mandatory?
		deferred
		end

	is_editable: BOOLEAN is
			-- Is Current editable - that is, does it have one or more
			-- parameters that can be changed?
		do
			-- Default to False - redefine if needed.
		end

feature -- Element change

	set_name (arg: STRING) is
			-- Set `name' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			name_implementation := clone (arg)
		ensure
			name_set: name_implementation.is_equal (arg) and name /= Void
		end

feature -- Basic operations

	execute (arg: ANY) is
			-- Execute the command with the specified argument.
		require
			arg_not_void_if_mandatory: arg_mandatory implies arg /= Void
		deferred
		end

	prepare_for_editing (editor: ANY) is
			-- Prepare `editor' for editing Current (not Current's children).
		require
			editable: is_editable
			editor_exists: editor /= Void
		do
			-- Default to null action - Redefine if needed.
		end

feature {NONE} -- Implementation

	name_implementation: STRING

feature {NONE} -- Implementation - Hook routine implementations

	alternate_status_tag: STRING is
		do
			Result := Current.generator + ": "
		end

	status_contents: STRING is
		do
			Result := "[no value]"
		end

invariant

end -- class COMMAND
