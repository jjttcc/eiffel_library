note
	description: "Facilities for exception handling and program termination -%
	% intended to be used via inheritance"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
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

	Error_exit_status: INTEGER = 1
			-- Error status for exit

	no_cleanup: BOOLEAN
			-- Should `termination_cleanup' NOT be called by `exit'?

	last_exception_status: EXCEPTION_STATUS
			-- Status of last exception that occurred, if any
		once
			create Result.make
		end

feature -- Status report

	verbose_reporting: BOOLEAN
			-- Should `error_information' include detailed
			-- exception information?  (Defaults to True.)
		do
			Result := not not_verbose_reporting
		end

feature -- Status setting

	set_verbose_reporting_on
			-- Set `verbose_reporting' to True.
		do
			not_verbose_reporting := False
		ensure
			verbose: verbose_reporting
		end

	set_verbose_reporting_off
			-- Set `verbose_reporting' to False.
		do
			not_verbose_reporting := True
		ensure
			not_verbose: not verbose_reporting
		end

feature -- Basic operations

	handle_exception (routine_description: STRING)
		local
			error_msg: STRING
			fatal: BOOLEAN
		do
			-- An exception may have caused a lock to have been left open -
			-- ensure that clean-up occurs to remove the lock:
			no_cleanup := False
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
					error_msg, error_information ("Exception", False)>>)
			elseif
				signal = Sigterm or signal = Sigabrt or signal = Sigquit
			then
				log_errors (<<"%NCaught kill signal in ", routine_description,
					":%N", signal_meaning (signal), " (", signal, ")",
					"%NDetails: ", error_information ("Exception ", True),
					"%Nexiting ...%N">>)
				fatal := True
			else
				log_errors (<<"%NCaught signal in ", routine_description,
					":%N", signal_meaning (signal), " (", signal, ")",
					"%NDetails: ", error_information ("Exception ", True)>>)
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

	exit (status: INTEGER)
			-- Exit the application with the specified status.  If `no_cleanup'
			-- is False, call `termination_cleanup'.
		do
			if verbose_reporting then
				if status /= 0 then
					log_information ("Aborting the " +
						application_name + ".%N")
				else
					log_information ("Terminating the " +
						application_name + ".%N")
				end
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

	end_program (i: INTEGER)
			-- Replacement for `die', since it appears to sometimes fail to
			-- exit
		external
			"C"
		end

	fatal_exception (e: INTEGER): BOOLEAN
			-- Is `e' an exception that is considered fatal?
		do
			Result := exception_list.has (e) and not (e = External_exception
				or e = Floating_point_exception or e = Routine_failure)
		end

	error_information (errname: STRING; stack_trace: BOOLEAN): STRING
			-- Information about the current exception, with a stack
			-- trace if `stack_trace'
		local
			errtag: STRING
		do
			if errname /= Void then
				errtag := errname
			else
				errtag := Default_errname
			end
			check
				errtag_exists: errtag /= Void
			end
			if exception = Void_call_target then
				-- Feature call on void target is a special case that can
				-- cause problems (specifically, OS signal when calling
				-- class_name) - so handle it separately.
				Result := errtag + " occurred: " +
					meaning (exception)
				if verbose_reporting then
					Result := Result + "%N[Exception trace:%N" +
					exception_trace + "]%N"
				end
			else
				Result := errtag + " occurred " +
					exception_routine_string + tag_string + class_name_string +
					exception_meaning_string (errname) + "%N"
				if verbose_reporting then
					if
						recipient_name /= Void and
						original_recipient_name /= Void and not
						recipient_name.is_equal (original_recipient_name)
					then
						Result := Result + "(Original routine where the violat%
							%ion occurred: " + original_recipient_name + ".)%N"
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

feature {NONE} -- Implementation - Hook routines

	application_name: STRING
			-- The name of the application to be used for error reporting
		once
			Result := "server"
		end

feature {NONE} -- Implementation

	exception_routine_string: STRING
		do
			Result := ""
			if verbose_reporting then
				Result := recipient_name
				if Result /= Void and then not Result.is_empty then
					Result := "in routine `" + Result + "' "
				else
					Result := ""
				end
			end
		ensure
			Result_exists: Result /= Void
		end

	tag_string: STRING
		local
			tgname: STRING
		do
			tgname := ""
			if tag_name /= Void then
				tgname := tag_name
			end
			if not tgname.is_empty then
				Result := ":%N%"" + tgname + "%"%N"
			else
				Result := ""
			end
		ensure
			Result_exists: Result /= Void
		end

	class_name_string: STRING
		do
			Result := ""
			if verbose_reporting then
				Result := class_name
				if Result /= Void and not Result.is_empty then
					Result := "from class %"" + Result + "%".%N"
				else
					Result := ""
				end
			end
		ensure
			Result_exists: Result /= Void
		end

	exception_meaning_string (errname: STRING): STRING
		do
			Result := ""
			if verbose_reporting then
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
		ensure
			Result_exists: Result /= Void
		end

	handle_assertion_violation
		do
			log_error (error_information (Assert_string, True))
			exit (Error_exit_status)
		end

	exception_list: ARRAY [INTEGER]
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

feature {NONE} -- Implementation

	not_verbose_reporting: BOOLEAN
			-- Should `error_information' NOT include detailed
			-- exception information?  (Allows defaulting to
			-- `verbose_reporting'.)

feature {NONE} -- Implementation - constants

	Assert_string: STRING = "Assertion violation"

	Default_errname: STRING = "Error"
			-- Default `errname' for `error_information' if none supplied

invariant

	verbose_not_verbose_are_opposites:
		verbose_reporting = not not_verbose_reporting

end
