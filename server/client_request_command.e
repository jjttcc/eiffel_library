indexing
	description: "A command that responds to a client request"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
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

	set_session (arg: like session) is
			-- Set session to `arg'.
		require
			arg_not_void: arg /= Void
		do
			session := arg
		ensure
			session_set: session = arg and session /= Void
		end

feature -- Basic operations

	execute (arg: ANY) is
			-- Call `do_execute' with `arg' and then `do_post_processing'.
		local
			exception_occurred: BOOLEAN
		do
			if exception_occurred then
				exception_cleanup
				-- If `handle_exception' in the rescue clause didn't exit,
				-- the exception was non-fatal.
				warn_client (<<"Error occurred ", error_context (arg), ".">>)
			else
				prepare_for_execution
				do_execute (arg)
				do_post_processing
			end
		rescue
			handle_exception ("responding to client request")
			exception_occurred := true
			retry
		end

feature {NONE} -- Hook routines

	do_execute (arg: ANY) is
			-- Produce response from `arg'.
		deferred
		end

	error_context (arg: ANY): STRING is
			-- Context for the current error - redefine as appropriate.
		do
			Result := ""
		end

	warn_client (slist: ARRAY [STRING]) is
			-- Report `slist' to the client as an error message.
		deferred
		end

	prepare_for_execution is
			-- Perform any needed preparation before `do_execute' is called.
		do
		end

	exception_cleanup is
			-- Perform any needed cleanup after an exception has occurred.
		do
		end

	do_post_processing is
			-- Perform any needed processing after `do_execute' is called.
		do
		end

end -- class CLIENT_REQUEST_COMMAND
