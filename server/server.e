indexing
	description:
		"Framework for a root class for a server application that responds %
		%to requests from clients"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
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

feature -- Initialization

	make is
		do
			if command_line_options.error_occurred then
				log_errors (<<"Error occurred during initialization - ",
					"exiting ...%N">>)
				exit (Error_exit_status)
			elseif command_line_options.help then
				command_line_options.print_usage
			elseif command_line_options.version_request then
				print_list (<<version.name, ", Version ", version.number, ", ",
					version.informal_date, "%N">>)
			elseif configuration_error then
				log_errors (<<"Error occurred during initialization:%N",
					config_error_description, ".%N">>)
				exit (Error_exit_status)
			else
				register_for_termination (Current)
				prepare_for_listening
				from
				until
					finished
				loop
					listen
				end
				exit (0)
			end
		rescue
			handle_exception ("main routine")
			exit (Error_exit_status)
		end

feature {NONE}

	finished: BOOLEAN
			-- Is it time to exit the server?

	prepare_for_listening is
			-- Do any necessary set-up before listening for client requests.
		deferred
		end

	listen is
			-- Listen for and respond to client requests.
		deferred
		end

	version: PRODUCT_INFO is
			-- Version information
		deferred
		end

	command_line_options: COMMAND_LINE is
			-- Command-line argument services
		deferred
		end

	cleanup is
			-- Do any needed cleanup before exiting.
		deferred
		end

	configuration_error: BOOLEAN is
			-- Is there an error in the MAS configuration?  If so,
			-- a description is placed into config_error_description.
		deferred
		end

	config_error_description: STRING

end -- SERVER
