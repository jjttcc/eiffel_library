indexing
	description: "Commands that execute a sequence of sub-commands"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class COMMAND_SEQUENCE inherit

	COMMAND
		redefine
			children, initialize
		end

create

	make

feature {NONE} -- Initialization

	make is
		do
			create {LINKED_LIST [COMMAND]} children.make
		end

feature -- Initialization

	initialize (arg: ANY) is
		do
			children.do_all (agent {COMMAND}.initialize (arg))
		end

feature -- Access

	children: LIST [COMMAND]
			-- The sub-commands to be executed

	main_operator: COMMAND
			-- The main operator, if one was specified

feature -- Status report

	arg_mandatory: BOOLEAN is
		do
			Result := children.there_exists (agent {COMMAND}.arg_mandatory)
		end

feature -- Element change

	add_child (c: COMMAND) is
			-- Add `c' to `children'.
		require
			c_exists: c /= Void
		do
			children.extend (c)
		ensure
			c_added: children.has (c) and children.count =
				old children.count + 1
		end

	set_main_operator (arg: COMMAND) is
			-- Set `main_operator' to `arg'.  Note: `execute' will only
			-- execute `main_operator' if it is in `children'.
		require
			arg_not_void: arg /= Void
		do
			main_operator := arg
		ensure
			main_operator_set: main_operator = arg and main_operator /= Void
		end

feature -- Removal

	wipe_out_children is
			-- Remove all children.
		do
			children.wipe_out
		ensure
			no_children: children.is_empty
		end

feature -- Basic operations

	execute (arg: ANY) is
		do
			children.do_all (agent {COMMAND}.execute (arg))
		end

end
