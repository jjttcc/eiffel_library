indexing
	description: "Facilities for exception handling and program termination -%
	% intended to be used via inheritance"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class EXCEPTION_SERVICES inherit

	EXCEPTIONS
		export
			{NONE} all
			{ANY} raise
		end

	UNIX_SIGNALS
		rename
			meaning as signal_meaning, ignore as ignore_signal,
			catch as catch_signal
		export
			{NONE} all
		end

	CLEANUP_SERVICES
		export
			{NONE} all
		end

feature -- Access

	Error_exit_status: INTEGER is 1
			-- Error status for exit

	no_cleanup: BOOLEAN
			-- Should `termination_cleanup' NOT be called by `exit'?

	last_exception_status: EXCEPTION_STATUS is
			-- Status of last exception that occurred, if any
		once
			create Result.make
		end

feature -- Basic operations

	handle_exception (routine_description: STRING) is
		local
			error_msg: STRING
			fatal: BOOLEAN
		do
			-- An exception may have caused a lock to have been left open -
			-- ensure that clean-up occurs to remove the lock:
			no_cleanup := false
			if assertion_violation then
				handle_assertion_violation
			elseif exception /= Signal_exception then
				if is_developer_exception then
					error_msg := ":%N" + developer_exception_name + "%N"
					fatal := last_exception_status.fatal
				else
					error_msg := "%N"
					fatal := last_exception_status.fatal or
						fatal_exception (exception)
				end
				log_errors (<<"%NError encountered - ", routine_description,
					error_msg, error_information ("Exception", false)>>)
			elseif
				signal = Sigterm or signal = Sigabrt or signal = Sigquit
			then
				log_errors (<<"%NCaught kill signal in ", routine_description,
					":%N", signal_meaning (signal), " (", signal, ")",
					"%NDetails: ", error_information ("Exception ", true),
					"%Nexiting ...%N">>)
				fatal := true
			else
				log_errors (<<"%NCaught signal in ", routine_description,
					":%N", signal_meaning (signal), " (", signal, ")",
					"%NDetails: ", error_information ("Exception ", true)>>)
				fatal := last_exception_status.fatal
				if fatal then
					log_error(" - exiting ...%N")
				else
					log_error(" - continuing ...%N")
				end
			end
			if fatal then
				exit (Error_exit_status)
			else
				last_exception_status.set_description ("")
			end
		end

	exit (status: INTEGER) is
			-- Exit the server with the specified status.  If `no_cleanup'
			-- is false, call `termination_cleanup'.
		do
			if status /= 0 then
				log_information ("Aborting the server.%N")
			else
				log_information ("Terminating the server.%N")
			end
			if not no_cleanup then
				debug ("persist")
					log_information ("Cleaning up ...%N")
				end
				termination_cleanup
				debug ("persist")
					log_information ("Finished cleaning up.%N")
				end
			end
			die (status)
			-- Sometimes die does not work - ensure program termination:
			end_program (status)
		rescue
			-- Make sure that program terminates when an exception occurs.
			die (status)
			end_program (status)
		end

	end_program (i: INTEGER) is
			-- Replacement for `die', since it appears to sometimes fail to
			-- exit
		external
			"C"
		end

	fatal_exception (e: INTEGER): BOOLEAN is
			-- Is `e' an exception that is considered fatal?
		do
			Result := exception_list.has (e) and not (e = External_exception
				or e = Floating_point_exception or e = Routine_failure)
		end

feature {NONE} -- Implementation

	exception_routine_string: STRING is
		do
			Result := recipient_name
			if Result /= Void and not Result.is_empty then
				Result := "in routine `" + Result + "' "
			else
				Result := ""
			end
		end

	tag_string: STRING is
		do
			Result := tag_name
			if Result /= Void and not Result.is_empty then
				Result := "with tag:%N%"" + Result + "%"%N"
			else
				Result := ""
			end
		end

	class_name_string: STRING is
		do
			Result := class_name
			if Result /= Void and not Result.is_empty then
				Result := "from class %"" + Result + "%".%N"
			else
				Result := ""
			end
		end

	exception_meaning_string (errname: STRING): STRING is
		do
			Result := meaning (exception)
			if Result /= Void and not Result.is_empty then
				if errname /= Void and not errname.is_empty then
					Result := "Type of " + errname + ": " +
						Result
				else
					Result := "(" + Result + ")"
				end
			else
				Result := ""
			end
		end

	error_information (errname: STRING; stack_trace: BOOLEAN): STRING is
			-- Information about the current exception, with a stack
			-- trace if `stack_trace'
		do
			if exception = Void_call_target then
				-- Feature call on void target is a special case that can
				-- cause problems (specifically, OS signal when calling
				-- class_name) - so handle it separately.
				Result := errname + " occurred: " +
					meaning (exception) + "%N[Exception trace:%N" +
					exception_trace + "]%N"
			else
				Result := errname + " occurred " +
					exception_routine_string + tag_string + class_name_string +
					exception_meaning_string (errname) + "%N"
				if
					recipient_name /= Void and original_recipient_name /= Void
					and not recipient_name.is_equal (original_recipient_name)
				then
					Result := Result +
						"(Original routine where the violation occurred: " +
						original_recipient_name + ".)%N"
				end
				if
					tag_name /= Void and original_tag_name /= Void and
					not tag_name.is_equal (original_tag_name)
				then
					Result := Result + "(Original tag name: " +
						original_tag_name + ".)%N"
				end
				if
					class_name /= Void and original_class_name /= Void and
					not class_name.is_equal (original_class_name)
				then
					Result := Result + "(Original class name: " +
						original_class_name + ".)%N"
				end
				if stack_trace then
					Result := Result + "%N[Exception trace:%N" +
						exception_trace + "]%N"
				end
			end
			if not last_exception_status.description.is_empty then
				if
					Result /= Void and not Result.is_empty and
					exception_list.has (exception)
				then
					Result := last_exception_status.description +
						" - " + Result
				else
					Result := last_exception_status.description + "%N"
				end
			end
		end

	handle_assertion_violation is
		do
			log_error (error_information ("Assertion violation", true))
			exit (Error_exit_status)
		end

	exception_list: ARRAY [INTEGER] is
			-- List of all known exception types
		once
			Result := <<Void_call_target, No_more_memory, Precondition,
				Postcondition, Floating_point_exception, Class_invariant,
				Check_instruction, Routine_failure, Incorrect_inspect_value,
				Loop_variant, Loop_invariant, Signal_exception,
				Rescue_exception, External_exception,
				Void_assigned_to_expanded, Io_exception,
				Operating_system_exception, Retrieve_exception,
				Developer_exception, Runtime_io_exception, Com_exception>>
		end

end -- EXCEPTION_SERVICES
