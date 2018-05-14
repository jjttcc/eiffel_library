note
    description:
        "Abstraction for a command that operates on two operands.  G is the %
        %type of the 'value' query and H is the type of the 'value' query %
        %for the two operands."
    author: "Jim Cochrane"
    date: "$Date$";
    revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"
    -- settings: vim: expandtab

deferred class BINARY_OPERATOR [G, H] inherit

    RESULT_COMMAND [G]
        redefine
            initialize, children
        end

    EXCEPTIONS
        export {NONE}
            all
        end

feature -- Initialization

    set_operands, make (op1: like operand1; op2: like operand2)
            -- Set the operands to the specified values.
        require
            not_void: op1 /= Void and op2 /= Void
        do
            set_operand1(op1)
            set_operand2(op2)
        ensure
            are_set: operand1 = op1 and operand2 = op2
            not_void: operand1 /= Void and operand2 /= Void
            parents_set: operand1.parents.has(Current) and
                operand2.parents.has(Current)
        end

    initialize (arg: ANY)
            -- Call initialize with arg on operand1 and operand2.
        do
            operand1.initialize (arg)
            operand2.initialize (arg)
        end

feature -- Access

    operand1: RESULT_COMMAND [H]
            -- The first operand to be operated on

    operand2: RESULT_COMMAND [H]
            -- The second operand to be operated on

    children: LIST [COMMAND]
        do
            create {LINKED_LIST [COMMAND]} Result.make
            Result.extend (operand1)
            Result.extend (operand2)
        end

feature -- Status report

    arg_mandatory: BOOLEAN
        do
            Result := operand1.arg_mandatory or operand2.arg_mandatory
        end

feature -- Element change

    set_operand1 (op: RESULT_COMMAND [H])
            -- Set `operand1' to `op'.
        require
            op_not_void: op /= Void
        do
            operand1 := op
            operand1.initialize_from_parent(Current)
        ensure
            operand1_set: operand1 = op and operand1 /= Void
            parents_set: operand1.parents.has(Current)
        end

    set_operand2 (op: RESULT_COMMAND [H])
            -- Set `operand2' to `op'.
        require
            op_not_void: op /= Void
        do
            operand2 := op
            operand2.initialize_from_parent(Current)
        ensure
            operand2_set: operand2 = op and operand2 /= Void
            parents_set: operand2.parents.has(Current)
        end

feature -- Basic operations

    execute (arg: ANY)
            -- A system exception may occur (most likely caused by division
            -- by 0) during execution of this feature.  In this case,
            -- the exception is caught and `value' is set to a default.
        local
            result1: H
            exception_occurred: BOOLEAN
        do
            if not exception_occurred then
                operand1.execute (arg)
                -- Save result to avoid possible side effects from executing
                -- operand2.
                result1 := operand1.value
                operand2.execute (arg)
                operate (result1, operand2.value)
            else
                set_value_to_default
            end
        rescue
            -- The most likely (perhaps only possible) exception is
            -- division by 0 in the operate feature, when the run-time
            -- type is DIVISION.
            exception_occurred := True
            retry
        end

feature {NONE} -- Hook routines

    operate (v1, v2: H)
        require
            not_void: v1 /= Void and v2 /= Void
        deferred
        ensure
            value_not_void: value /= Void
        end

    set_value_to_default
            -- Set `value' to a default value to handle exception condition.
        do
            value := value.default
        end

end -- class BINARY_OPERATOR
