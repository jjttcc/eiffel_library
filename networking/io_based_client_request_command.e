note
	description: "CLIENT_REQUEST_COMMANDs that use an IO_MEDIUM to respond %
		%to the client request"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class IO_BASED_CLIENT_REQUEST_COMMAND inherit

	CLIENT_REQUEST_COMMAND
		rename
			do_post_processing as respond_to_client
		redefine
			prepare_for_execution, exception_cleanup,
			respond_to_client
		end

feature -- Initialization

	make
		do
			create output_buffer.make (0)
		end

feature -- Access

	output_medium: IO_MEDIUM
			-- Medium for output

feature -- Element change

	set_output_medium (arg: IO_MEDIUM)
			-- Set output_medium to `arg'.
		require
			arg_not_void: arg /= Void
		do
			output_medium := arg
		ensure
			output_medium_set: output_medium = arg and output_medium /= Void
		end

feature {NONE}

	output_buffer: STRING
			-- Buffer containing output to be sent to the client

	output_buffer_used: BOOLEAN
			-- Is the `output_buffer' used?  Yes - redefine for
			-- descendants that don't use it.
		once
			Result := True
		end

	put (s: STRING)
			-- Append `s' to `output_buffer'.
		require
			buffer_not_void: output_buffer /= Void
		do
			output_buffer.append (s)
		ensure
			new_count: output_buffer.count = old output_buffer.count + s.count
		end

	report_error (code: INTEGER; slist: ARRAY [ANY])
			-- Report `slist' as an error message; include `code' ID at the
			-- beginning and `eom' at the end.
		do
			put (concatenation (<<code.out, "%T">>))
			put (concatenation (slist))
			put (eom)
		end

	put_ok
			-- Append ok_string to `output_buffer'.
		require
			buffer_not_void: output_buffer /= Void
		do
			put (ok_string)
		ensure
			new_count: output_buffer.count = old output_buffer.count +
				ok_string.count
		end

feature {NONE} -- Hook routines

	warning: INTEGER
			-- Response code for sending a "warning" to the client
		deferred
		end

	error: INTEGER
			-- Response code for sending error-status notification
			-- to the client
		deferred
		end

	eom: STRING
			-- End of message indicator
		deferred
		end

	ok_string: STRING
			-- String indicating "OK" status to the client
		deferred
		end

feature {NONE} -- Hook routine implementations

	warn_client (slst: ARRAY [STRING])
		do
			report_error (Warning, slst)
			respond_to_client (slst)
		end

	prepare_for_execution (arg: ANY)
		do
			if output_buffer_used then
				output_buffer.wipe_out
			end
		end

	exception_cleanup (arg: ANY)
		do
			prepare_for_execution (arg)
			warn_client (<<"Error occurred ", error_context (arg.out), ".">>)
		end

	respond_to_client (arg: ANY)
			-- Send `output_buffer' to the `output_medium'.
		do
			if not output_buffer.is_empty then
				output_medium.put_string (output_buffer)
			end
		end

feature {NONE} -- Implementation

	error_context (arg: ANY): STRING
		do
			Result := ""
		end

invariant

	output_buffer_not_void: output_buffer /= Void

end
