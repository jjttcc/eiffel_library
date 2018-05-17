note
    description: "Commands with a result of generic type G";
    author: "Jim Cochrane"
    date: "$Date$";
    revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    -- settings: vim: expandtab

deferred class RESULT_COMMAND [G] inherit

    COMMAND
        redefine
            status_contents, initialize_from_parent
        end

feature -- Access

    value: G
            -- The result of execution

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

feature {NONE} -- Implementation - Hook routine implementations

    status_contents: STRING
        do
            Result := "value: " + value.out
        end

end -- class RESULT_COMMAND
