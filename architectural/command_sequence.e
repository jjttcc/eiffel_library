note
    description: "Commands that execute a sequence of sub-commands"
    author: "Jim Cochrane"
    date: "$Date$";
    revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    -- settings: vim: expandtab

class COMMAND_SEQUENCE inherit

    COMMAND
        redefine
            children, initialize, initialize_from_parent
        end

create

    make

feature {NONE} -- Initialization

    make
        do
            create {LINKED_LIST [COMMAND]} children.make
        end

feature -- Initialization

    initialize (arg: ANY)
        do
            children.do_all (agent {COMMAND}.initialize (arg))
        end

feature -- Access

    children: LIST [COMMAND]
            -- The sub-commands to be executed

    main_operator: COMMAND
            -- The main operator, if one was specified

feature -- Status report

    arg_mandatory: BOOLEAN
        do
            Result := children.there_exists (agent {COMMAND}.arg_mandatory)
        end

feature -- Status setting

    initialize_from_parent(p: TREE_NODE)
        do
            if parents_implementation = Void then
                create {LINKED_LIST [TREE_NODE]} parents_implementation.make
            end
            -- Prevent adding the same parent twice.
            if not is_parent(p) then
                parents_implementation.extend(p)
            end
        ensure then
            p_is_a_parent: parents.has(p)
        end

feature -- Element change

    add_child (c: COMMAND)
            -- Add `c' to `children'.
        require
            c_exists: c /= Void
        do
            children.extend (c)
        ensure
            c_added: children.has (c) and children.count =
                old children.count + 1
        end

    set_main_operator (arg: COMMAND)
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

    wipe_out_children
            -- Remove all children.
        do
            children.wipe_out
        ensure
            no_children: children.is_empty
        end

feature -- Basic operations

    execute (arg: ANY)
        do
            children.do_all (agent {COMMAND}.execute (arg))
        end

end
