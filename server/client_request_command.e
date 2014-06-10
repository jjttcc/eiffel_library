note
	description: "A command that responds to a client request"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class CLIENT_REQUEST_COMMAND inherit

	COMMAND

	EXCEPTION_SERVICES
		export
			{NONE} all
		end

feature -- Access

	session: SESSION
			-- Settings specific to a particular client session

feature -- Status setting

	set_session (arg: like session)
			-- Set session to `arg'.
		require
			arg_not_void: arg /= Void
		do
			session := arg
		ensure
			session_set: session = arg and session /= Void
		end

feature -- Basic operations

	execute (arg: ANY)
			-- Call `do_execute' with `arg' and then `do_post_processing'.
		local
			exception_occurred: BOOLEAN
		do
			if exception_occurred then
				exception_cleanup (arg)
			else
				execution_retries := 0
				prepare_for_execution (arg)
				if do_execute_precondition then
					do_execute (arg)
					do_post_processing (arg)
				else
					failure_cleanup (arg)
				end
			end
		rescue
			handle_exception ("responding to client request")
			if execution_retries = Maximum_execution_tries then
				exit (1)
			else
				execution_retries := execution_retries + 1
				exception_occurred := True
				retry
			end
		end

feature {NONE} -- Hook routines

	do_execute (arg: ANY)
			-- Produce response from `arg'.
		require
			arg_not_void_if_mandatory: arg_mandatory implies arg /= Void
			do_execute_precondition: do_execute_precondition
		deferred
		end

	prepare_for_execution (arg: ANY)
			-- Perform any needed preparation before `do_execute' is called.
		do
		end

	exception_cleanup, failure_cleanup (arg: ANY)
			-- Perform any needed cleanup after an exception or failer
			-- has occurred.
		do
			-- Default to null action - redefine as needed.
			-- If these two routines need to do different things,
			-- redefine them separately.
		end

	do_post_processing (arg: ANY)
			-- Perform any needed processing after `do_execute' is called.
		do
		end

	do_execute_precondition: BOOLEAN
			-- Precondition for `do_execute'
		once
			Result := True
		end

feature {NONE} -- Implementation

	execution_retries: INTEGER
			-- Number of times `execute' caught an exception and retried

	Maximum_execution_tries: INTEGER
			-- Maximum number of times for `execute' to retry before aborting
		once
			-- Redefine as needed.
			Result := 1
		end

invariant

	Maximum_execution_tries >= 0 and
		execution_retries <= Maximum_execution_tries

end -- class CLIENT_REQUEST_COMMAND
