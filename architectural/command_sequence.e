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
            children, initialize, initialize_from_parent, who_am_i__parent
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
            parents_implementation.extend(p)
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

feature {TREE_NODE} -- Implementation

    who_am_i__parent (child: TREE_NODE): STRING
        local
            object_comparison: BOOLEAN
            ch_cmd: COMMAND
			s: STRING
            prnts: LIST [TREE_NODE]
        do
            object_comparison := False
            Result := ""
            if children.object_comparison then
                object_comparison := True
                children.compare_references
            end
            ch_cmd ?= child
            children.search(ch_cmd)
            if not children.exhausted then
                -- Acknowledge: Current is child's parent
                Result := "for <" + name + ">: child at position " +
                    children.index.out
Result := "[cmdseq/" + hash_code.out + "] "
if false then
                if ch_cmd = main_operator then
                    Result := Result + ", main operator"
                end
                -- Append "who-am-i" report for Current with respect to its
                -- parents.
                from
                    prnts := parents
                    prnts.start
                until
                    prnts.exhausted
                loop
                    s := prnts.item.who_am_i__parent(Current)
                    if not s.empty then
                        Result := Result + "; " + s
                    end
                    prnts.forth
                end
 end
            end
            if object_comparison then
                children.compare_objects
            end
        ensure then
            -- empty_iff_not_child: children.has(child) = not Result.empty
        end

end
