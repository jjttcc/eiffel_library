note
    description: "Objects that are nodes in a hierarchical tree structure"
    author: "Jim Cochrane"
    date: "$Date$";
    revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    -- settings: vim: expandtab

deferred class TREE_NODE inherit

    HASHABLE

feature -- Access

    children: LIST [like Current]
            -- Current's children
        deferred
        ensure
            not_void: Result /= Void
        end

    descendants: like children
            -- All of Current's descendants (excluding Current) - children,
            -- children's children, etc., with duplicates removed
        local
            l: like descendants
            node_set: LINKED_SET [like children.item]
        do
            create {LINKED_LIST [like children.item]} Result.make
            if not descendants_locked then
                lock_descendants
                l := copy_of_children
                create node_set.make
                if descendant_comparison_is_by_objects then
                    node_set.compare_objects
                end
                from l.start until l.exhausted loop
                    node_set.extend (l.item)
                    node_set.append (l.item.descendants)
                    l.forth
                end
                Result.append (node_set)
                unlock_descendants
            end
        ensure
            exists: Result /= Void
            current_excluded: not tree_contains_cycle (
                create {HASH_TABLE [BOOLEAN, STRING]}.make (0)) implies
                not Result.has (Current)
            same_lock_state: descendants_locked = old descendants_locked
        end

    name: STRING
            -- Current's name
        do
            -- Redefine as needed.
            Result := ""
        ensure
            exists: Result /= Void
        end

    node_type: STRING
        do
            Result := generating_type.out
        end

    all_components: CHAIN [ANY]
            -- All "important" components of Current (including
            -- `descendants' and Current itself), where "important" is
            -- determined by each particular TREE_NODE descendant
            -- class (i.e., class author)
        local
            unique_table: HASH_TABLE [BOOLEAN, like Current]
            nodes: like descendants
            complist: CHAIN [ANY]
            keys: LINEAR [TREE_NODE]
            comp: ANY
        do
            create unique_table.make(0)
            unique_table.compare_references
            create {LINKED_LIST [ANY]} complist.make
            nodes := descendants
            nodes.extend(Current)
            nodes.do_all(agent (node: like Current;
                    table: HASH_TABLE [BOOLEAN, like Current];
                    clist: CHAIN [ANY])
                do
                    table.put(true, node)
                    clist.append(node.direct_components)
                end
                (?, unique_table, complist))
            complist.do_all(agent (c: like Current;
                    table: HASH_TABLE [BOOLEAN, like Current])
                do
                    table.put(true, c)
                end
                (?, unique_table))
            create {LINKED_LIST [ANY]} Result.make
            keys := unique_table.current_keys.linear_representation
            from
                keys.start
            until
                keys.exhausted
            loop
                comp ?= keys.item
                if comp /= Void then
                    Result.extend(comp)
                end
                keys.forth
            end
        ensure
            not_empty: Result /= Void and then not Result.is_empty
        end

    direct_components: CHAIN [ANY]
            -- All direct (non-descendant) ("important") components of
            -- Current, excluding Current itself
        do
        ensure
            exists: Result /= Void
        end

    parents: LIST [TREE_NODE]
            -- The TREE_NODE(s) (if any) that "contain" Current - If no
            -- object contains Current: Result.empty
        do
            if parents_implementation = Void then
                create {LINKED_LIST [TREE_NODE]} parents_implementation.make
            end
            Result := parents_implementation
        ensure
            existence: Result /= Void
        end

    ancestors: TWO_WAY_TREE [TREE_NODE]
            -- Current's ancestors, in order: i.e., parent,
            -- parent's parent, etc (including Current).
        local
            prnts: LIST [TREE_NODE]
        do
            prnts := parents
            create Result.make(Current)
            if not prnts.empty then
                from
                    prnts.start
                until
                    prnts.exhausted
                loop
                    Result.child_finish
                    Result.put_child_right(prnts.item.ancestors)
                    prnts.forth
                end
            end
        ensure
            existence: Result /= Void
            empty_iff_no_parents: Result.empty = not has_parents
            parents_count_or_more: Result.count >= parents.count
        end

feature -- Status report

    has_parents: BOOLEAN
            -- Does Current have any parents?
        do
            Result := not parents.empty
        ensure
            definition: Result = not parents.empty
        end

    status: STRING
            -- Status of Current (not its desdendants) - for debugging
        do
            Result := status_tag + status_contents
        ensure
            Result_exists: Result /= Void
        end

    status_report: STRING
            -- Report on the status of Current and its descendants -
            -- for debugging
        do
            Result := report (0, agent {TREE_NODE}.status)
        end

    node_names: STRING
            -- The name of this node and all descendants, formatted
            -- according to the current tree hierarchy
        do
            Result := report (0, agent {TREE_NODE}.name)
        end

    tree_contains_cycle (visited: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
            -- Does the tree with Current as the root contain a cycle?
        require
            arg_exists: visited /= Void
        local
            current_tag: STRING
            l: like children
        do
            current_tag := out
            -- If Current has already been visited for this cycle check,
            -- then there is a cycle:
            Result := visited @ current_tag
            if not Result then
                visited.force (True, current_tag)
                from
                    l := children
                    l.start
                until
                    Result or else l.exhausted
                loop
                    Result := l.item.tree_contains_cycle (visited)
                    l.forth
                end
                visited.force (False, current_tag)
            end
        ensure
            true_if_already_visited: old (visited @ out) implies Result
        end

feature -- Element change

    initialize_from_parent (p: TREE_NODE)
            -- Perform any needed initialization of Current using potential
            -- parent `p' - for the most likely example, set a `parent'
            -- attribute to `p'.
        require
            existence: p /= Void
        do
            -- Default to <null> action - redefine in descendant if needed.
        end

feature {NONE} -- Implementation - Hook routines

    copy_of_children: like children
            -- Copy of `children' - Default to a reference to `children'.
            -- Redefine to use clone or deep_clone if needed.
        do
            Result := children
        ensure
            result_exists: Result /= Void
        end

    descendant_comparison_is_by_objects: BOOLEAN
            -- Should object_comparison be used (as opposed to reference
            -- comparison) to remove duplicates from `descendants'?
        do
            -- Default to False - Redefine if object comparsion is needed.
        end

    status_tag: STRING
        do
            -- Default status tag - redefine as needed.
            if name.is_empty then
                Result := alternate_status_tag
            else
                Result := name + ": "
            end
        end

    status_contents: STRING
        do
            -- Default status contents - redefine as needed.
            Result := "OK"
        end

    alternate_status_tag: STRING
            -- Alternate status tag if `name' is empty
        do
            -- Redefine as needed.
            Result := "status: "
        end

    empty_report_string: STRING
            -- String to substitute for an empty report result
        do
            Result := ""
        end

    descendants_locked: BOOLEAN
            -- Implementation state to prevent infinite calls to descendants
            -- when Current is part of a cycle - Redefine appropriately,
            -- along with `lock_descendants' and `unlock_descendants',
            -- if this functionality is required.
        do
            Result := False
        end

    lock_descendants
        do
        end

    unlock_descendants
        do
        end

    descendant_components: CHAIN [ANY]
            -- All `components' of each member of `descendants'
        do
            create {LINKED_LIST [ANY]} Result.make  -- Default to empty list
        end

feature {TREE_NODE} -- Implementation

    report (indent_size: INTEGER;
        report_function: FUNCTION [ANY, TUPLE [], STRING]): STRING
            -- Information about Current with hierarchical indenting, using
            -- `report_function' for the report contents
        local
            spaces: STRING
            chl: LIST [TREE_NODE]
            child_indent: INTEGER
            i: INTEGER
        do
            create spaces.make (0)
            from i := 1 until i > indent_size loop
                spaces.extend (' ')
                i := i + 1
            end
            -- Ensure that Current is the target for the call
            -- of `report_function'.
            report_function.set_operands ([Current])
            report_function.apply
            if
                report_function.last_result /= Void and then
                not report_function.last_result.is_empty
            then
                Result := spaces + report_function.last_result + "%N"
            else
                Result := empty_report_string
            end
            child_indent := indent_size + Indent_increment
            from
                chl := children
                chl.start
            until
                chl.exhausted
            loop
                Result := Result + chl.item.report (child_indent,
                    report_function)
                chl.forth
            end
        end

feature {NONE} -- Implementation

    parents_implementation: LIST [TREE_NODE]

feature {NONE} -- Hook routine implementations

    hash_code: INTEGER
        do
            Result := name.hash_code
        end

feature {NONE} -- Implementation - constants

    Indent_increment: INTEGER = 3

invariant

    children_exist: children /= Void
    descendants_exist: descendants /= Void
    children_and_descendants_correspond: not descendants_locked implies
        children.is_empty = descendants.is_empty
    name_not_void: name /= Void
    parents_exist: parents /= Void

end
