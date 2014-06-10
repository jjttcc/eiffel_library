note
	description:
		"Framework for a root class for a server application that responds %
		%to requests from clients"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class SERVER inherit

	EXCEPTION_SERVICES
		export
			{NONE} all
		end

	TERMINABLE
		export
			{NONE} all
		end

	GENERAL_UTILITIES
		export
			{NONE} all
		end

feature -- Initialization

	make
		do
			if command_line_options.error_occurred then
				log_errors (<<"Error occurred during initialization - ",
					command_line_error_description, "exiting ...%N">>)
				exit (Error_exit_status)
			elseif command_line_options.help then
				command_line_options.print_usage
			elseif command_line_options.version_request then
				print_list (<<version.name, ", Version ", version.number, ", ",
					version.informal_date, "%N",
					version.assertion_report, "%N">>)
			elseif configuration_error then
				log_errors (<<"Error occurred during initialization:%N",
					config_error_description, ".%N">>)
				exit (Error_exit_status)
			else
				register_for_termination (Current)
				initialize
				prepare_for_listening
				from
				until
					finished
				loop
					pre_listen
					listen
					post_listen
				end
				exit (0)
			end
		rescue
			handle_exception ("main routine")
			exit (Error_exit_status)
		end

feature {NONE} -- Hook routines

	initialize
			-- Perform any needed initialization before
			-- calling `prepare_for_listening'.
		do
			-- Null action - redefine if needed.
		end

	prepare_for_listening
			-- Do any necessary set-up before listening for client requests.
		deferred
		end

	listen
			-- Listen for and respond to client requests.
		deferred
		end

	pre_listen
			-- Perform any needed preparation before the next call to `listen'.
		do
			-- Null procedure - redefine if needed.
		end

	post_listen
			-- Perform any needed post-processing after the last call
			-- to `listen'.
		do
			-- Null procedure - redefine if needed.
		end

	version: PRODUCT_INFO
			-- Version information
		deferred
		end

	command_line_options: COMMAND_LINE
			-- Command-line argument services
		deferred
		end

	configuration_error: BOOLEAN
			-- Is there an error in the MAS configuration?  If so,
			-- a description is placed into config_error_description.
		deferred
		end

feature {NONE}

	finished: BOOLEAN
			-- Is it time to exit the server?

	config_error_description: STRING

	command_line_error_description: STRING
		do
			if non_empty_string (command_line_options.error_description) then
				Result := "%N" + command_line_options.error_description +
					" - "
			else
				Result := ""
			end
		end

end -- SERVER
