note
	description: "A SERVER that polls for available IO_MEDIUMs"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class POLLING_SERVER inherit

	SERVER
		rename
			make as server_make
		redefine
			exit, log_errors
		end

feature {NONE} -- Initialization

	make
		do
			create errors.make (0)
			server_make
		end

feature {NONE} -- Hook routine implementation

	prepare_for_listening
		do
			create poller.make_read_only
			make_current_media
			from
				current_media.start
			until
				current_media.exhausted
			loop
				poller.put_read_command (read_command_for (current_media.item))
				current_media.forth
			end
			if additional_read_commands /= Void then
				additional_read_commands.do_all (agent poller.put_read_command)
			end
			report_errors (errors)
		ensure then
			poller_exists: poller /= Void
		end

	listen
			-- Listen for and respond to client requests.
		do
			check
				poller: poller /= Void
			end
			poller.execute (15, Polling_timeout_milliseconds)
		end

	cleanup
			-- Close all unclosed IO_MEDIUMs.
		local
			ex_srv: expanded EXCEPTION_SERVICES
		do
			if not ex_srv.last_exception_status.description.is_empty then
				if errors.is_empty then
					errors := ex_srv.last_exception_status.description
				else
					errors := errors + "%N" +
						ex_srv.last_exception_status.description
				end
			end
			if current_media /= Void then
				from
					current_media.start
				until
					current_media.exhausted
				loop
					if not current_media.item.is_closed then
						current_media.item.close
					end
					current_media.forth
				end
			end
			if not errors.is_empty then
				report_errors (errors)
			end
		end

	notify (msg: STRING)
		do
			errors.append (msg + "%N")
		end

	exit (status: INTEGER)
		do
			if command_line_options.error_occurred then
				errors := errors + command_line_options.error_description
			end
			report_errors (errors)
			Precursor (status)
		end

	log_errors (a: ARRAY [ANY])
		local
			l: LINEAR [ANY]
		do
			Precursor (a)
			from
				l := a.linear_representation
				l.start
			until
				l.exhausted
			loop
				errors := errors + l.item.out
				l.forth
			end
		end

feature {NONE} -- Implementation - Hook routines

	make_current_media
			-- Create and fill `current_media'.
		deferred
		ensure
			current_media_exist: current_media /= Void
		end

	read_command_for (medium: IO_MEDIUM): POLL_COMMAND
			-- A poll command for reading `medium'
		deferred
		end

	additional_read_commands: LINEAR [POLL_COMMAND]
			-- Read commands to be used in addition to those associated with
			-- the elements of `current_media'
		deferred
		end

	Polling_timeout_milliseconds: INTEGER
			-- Polling timeout value, in milliseconds
		once
			Result := 20000
		end

feature {NONE} -- Implementation

	report_errors (errs: STRING)
			-- Report `errors' to any interested clients.
		do
			-- Null action - redefine as needed.
		end

feature {NONE} -- Implementation - Attributes

	poller: MEDIUM_POLLER
			-- Poller for available IO_MEDIUMs

	current_media: LIST [IO_MEDIUM]

	errors: STRING
			-- List of error messages to "report back" to the startup process

invariant

end
