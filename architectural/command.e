indexing
	description: "Basic abstraction for an executable command"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class 

	COMMAND

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
			create {LINKED_LIST [COMMAND]} Result.make
		ensure
			not_void: Result /= Void
		end

	descendants: LIST [COMMAND] is
			-- All of this command's descendants, if this is a composite
			-- command - children, children's children, etc.
		local
			l: LIST [COMMAND]
		do
			create {LINKED_LIST [COMMAND]} Result.make
			l := children
			from l.start until l.exhausted loop
				Result.extend (l.item)
				Result.append (l.item.descendants)
				l.forth
			end
		ensure
			not_void: Result /= Void
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

feature -- Basic operations

	execute (arg: ANY) is
			-- Execute the command with the specified argument.
		require
			arg_not_void_if_mandatory: arg_mandatory implies arg /= Void
		deferred
		end

feature -- Status report

	arg_mandatory: BOOLEAN is
			-- Is the argument to execute mandatory?
		deferred
		end

invariant

	children_and_descendants_correspond: children.is_empty = descendants.is_empty

end -- class COMMAND
