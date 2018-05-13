note
    description:
        "A RESULT_COMMAND that takes an operand (also of type RESULT_COMMAND) %
        %and operates on its result.  G is the type of the 'value' feature %
        %and H is the type of the operand's 'value' feature."
    author: "Jim Cochrane"
    date: "$Date$";
    revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    -- settings: vim: expandtab

class UNARY_OPERATOR [G, H] inherit

    RESULT_COMMAND [G]
        redefine
            initialize, children, who_am_i__parent
        end

feature -- Initialization

    initialize (arg: ANY)
        do
            operand.initialize (arg)
        end

feature -- Access

    operand: RESULT_COMMAND [H]

    children: LIST [COMMAND]
        do
            create {LINKED_LIST [COMMAND]} Result.make
            Result.extend (operand)
        end

feature -- Status report

    arg_mandatory: BOOLEAN
        do
            Result := operand.arg_mandatory
        end

feature -- Status setting

    set_operand (op: like operand)
            -- Set operand to `op'.
        require
            op /= Void
        do
            operand := op
            operand.initialize_from_parent(Current)
        ensure
            operand_set: operand = op and operand /= Void
            parents_set: operand.parents.has(Current)
        end

feature -- Basic operations

    execute (arg: ANY)
        do
            operand.execute (arg)
            operate (operand.value)
        end

feature {TREE_NODE} -- Implementation

    who_am_i__parent (child: TREE_NODE): STRING
        do
            Result := ""
			if child = operand then
				Result := who_am_i_intro + " operand"
			end
            if not Result.empty then
                Result := Result + recursive_who_am_i
            else
                -- Since Result is empty, assume Current is not its parent
                -- and leave it empty.
            end
        end

feature {NONE} -- Hook routines

    operate (v: H)
            -- Null action by default
        require
            not_void: v /= Void
        do
        ensure
            value_not_void: value /= Void
        end

invariant

    op_not_void: operand /= Void

end -- class UNARY_OPERATOR
