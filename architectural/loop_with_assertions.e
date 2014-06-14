note
	description: "LOOP_COMMANDs that that include a loop invariant and %
		%loop variant"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class LOOP_WITH_ASSERTIONS inherit

	LOOP_COMMAND
		redefine
			initialize, children, arg_mandatory, execute
		end

	GENERAL_UTILITIES
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	initialize (arg: ANY)
		do
			Precursor (arg)
			if loop_invariant /= Void then
				loop_invariant.initialize (arg)
			end
			if loop_variant /= Void then
				loop_variant.initialize (arg)
			end
		end

feature -- Access

	loop_invariant: RESULT_COMMAND [BOOLEAN]
			-- The loop invariant

	loop_variant: RESULT_COMMAND [DOUBLE]
			-- The loop variant - ceiling is used to obtain an integer

	children: LIST [COMMAND]
		do
			Result := Precursor
			if loop_invariant /= Void then
				Result.extend (loop_invariant)
			end
			if loop_variant /= Void then
				Result.extend (loop_variant)
			end
		end

feature -- Status report

	arg_mandatory: BOOLEAN
		do
			Result := Precursor or (loop_invariant /= Void and then
				loop_invariant.arg_mandatory) or
				(loop_variant /= Void and then loop_variant.arg_mandatory)
		end

feature -- Element change

	set_loop_invariant (arg: RESULT_COMMAND [BOOLEAN])
			-- Set `loop_invariant' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			loop_invariant := arg
		ensure
			loop_invariant_set: loop_invariant = arg and loop_invariant /= Void
		end

	set_loop_variant (arg: RESULT_COMMAND [DOUBLE])
			-- Set `loop_variant' to `arg'.
		require
			arg_not_void: arg /= Void
		do
			loop_variant := arg
		ensure
			loop_variant_set: loop_variant = arg and loop_variant /= Void
		end

feature -- Basic operations

	execute (arg: ANY)
		do
			from
				initialization.execute (arg)
				initialize_variant (arg)
			until
				terminate (arg)
			loop
				check_invariant (arg)
				body.execute (arg)
				check_variant (arg)
			end
			check_invariant (arg)
			value := body.value
		end

feature {NONE} -- Implementation

	check_invariant (arg: ANY)
		do
			loop_invariant.execute (arg)
			if not loop_invariant.value then
				log_error ("Loop invariant violation:%N" + "command name: '" +
					loop_invariant.name + "', status: " +
					loop_invariant.status_report + "%N")
			end
		end

	check_variant (arg: ANY)
		local
			i: INTEGER
		do
			loop_variant.execute (arg)
			i := loop_variant.value.ceiling
			if i >= last_variant_value then
				log_error ("Loop variant violation:%Nprevious value: " +
					last_variant_value.out + ", current value: " +
					value.out + "%N")
			end
			last_variant_value := i
		end

	initialize_variant (arg: ANY)
		do
			loop_variant.execute (arg)
			last_variant_value := loop_variant.value.ceiling
		end

	last_variant_value: INTEGER
			-- Value of the loop variant the last time it was checked

invariant

end
