note
	description: "Commands that emulate a loop construct"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class LOOP_COMMAND inherit

	RESULT_COMMAND [DOUBLE]
		redefine
			initialize, children
		end

	MATH_CONSTANTS
		export
			{NONE} all
			{ANY} epsilon
		end

creation

	make

feature -- Initialization

	make (init_cmd: like initialization;
			term_cond: like termination_condition; bdy: like body)
		require
			args_not_void: init_cmd /= Void and term_cond /= Void and
				bdy /= Void
		do
			initialization := init_cmd
			termination_condition := term_cond
			body := bdy
		ensure
			init_set: initialization = init_cmd and
				initialization /= Void
			term_cond_set: termination_condition = term_cond and
				termination_condition /= Void
			body_set: body = bdy and body /= Void
		end

	initialize (arg: ANY)
		do
			initialization.initialize (arg)
			termination_condition.initialize (arg)
			body.initialize (arg)
		end

feature -- Access

	initialization: COMMAND
			-- Command to perform any needed initialization before
			-- executing the loop

	termination_condition: RESULT_COMMAND [BOOLEAN]
			-- Boolean condition that, when true, terminates the loop

	body: RESULT_COMMAND [DOUBLE]
			-- Command that executes the body of the loop, after which
			-- `value' is set to `body.value'

	children: LIST [COMMAND]
		do
			create {LINKED_LIST [COMMAND]} Result.make
			Result.extend (initialization)
			Result.extend (termination_condition)
			Result.extend (body)
		end

feature -- Status report

	arg_mandatory: BOOLEAN
		do
			Result := initialization.arg_mandatory or
				termination_condition.arg_mandatory or body.arg_mandatory
		end

feature -- Basic operations

	execute (arg: ANY)
		do
			from
				initialization.execute (arg)
			until
				terminate (arg)
			loop
				body.execute (arg)
			end
			value := body.value
		ensure then
			value_eq_body_value: (value - body.value).abs < epsilon
			terminated: termination_condition.value
		end

feature {NONE} -- Implementation

	terminate (arg: ANY): BOOLEAN
			-- Does termination_condition produce a result of true?
		do
			termination_condition.execute (arg)
			Result := termination_condition.value
		end

invariant

	init_not_void: initialization /= Void
	termination_condition_not_void: termination_condition /= Void
	body_not_void: body /= Void

end
