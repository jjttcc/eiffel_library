indexing
	description: "ECLI/database tools"
	author: "Jim Cochrane"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "Copyright 2004: Jim Cochrane - License to be determined."

deferred class ECLI_TOOLS inherit

	ERROR_PUBLISHER

feature -- Access

	last_error: STRING
			-- Description of last error that occurred

feature -- Access - Queries

	string_list_from_query (q: STRING): LIST [STRING] is
			-- A list of STRING resulting from SQL query `q'
		require
			q_exists: q /= Void and then not q.is_empty
		local
			stmt: ECLI_STATEMENT
			ecli_string: ECLI_VARCHAR
			s: STRING
		do
			error_occurred := False
			create {ARRAYED_LIST [STRING]} Result.make (0)
			create stmt.make (session)
			-- No need to prepare:
			stmt.set_immediate_execution_mode
			stmt.set_sql (q)
			execute_statement (stmt)
			if not error_occurred then
				-- Create result set 'value holders'.
				create ecli_string.make (20)
				check stmt.result_column_count > 0 end
				-- Define the container of value holders.
				stmt.set_cursor (<<ecli_string>>)
				-- Iterate on result-set.
				from
					stmt.start
				until
					stmt.off
				loop
					if not stmt.cursor.item (1).is_null then
						s ?= stmt.cursor.item (1).item
						Result.extend (s)
					end
					stmt.forth
				end
			end
			stmt.close
		ensure then
			result_exists: Result /= Void
			empty_on_error: error_occurred implies Result.is_empty
		end

	integer_list_from_query (q: STRING): LIST [INTEGER] is
			-- An INTEGER resulting from SQL query `q'
		require
			q_exists: q /= Void and then not q.is_empty
		local
			stmt: ECLI_STATEMENT
			ecli_integer: ECLI_INTEGER
			i: INTEGER_REF
		do
			error_occurred := False
			create {ARRAYED_LIST [INTEGER]} Result.make (0)
			create stmt.make (session)
			-- No need to prepare:
			stmt.set_immediate_execution_mode
			stmt.set_sql (q)
			execute_statement (stmt)
			if not error_occurred then
				create ecli_integer.make
				-- Create result set 'value holders'.
				check stmt.result_column_count > 0 end
				-- Define the container of value holders.
				stmt.set_cursor (<<ecli_integer>>)
				-- Iterate on result-set.
				from
					stmt.start
				until
					stmt.off
				loop
					if not stmt.cursor.item (1).is_null then
						i ?= stmt.cursor.item (1).item
						Result.extend (i.item)
					end
					stmt.forth
				end
			end
			stmt.close
		ensure then
			result_exists: Result /= Void
			empty_on_error: error_occurred implies Result.is_empty
		end

	integer_from_query (q: STRING): INTEGER is
			-- An INTEGER resulting from SQL query `q'
		require
			q_exists: q /= Void and then not q.is_empty
		local
			l: LIST [INTEGER]
		do
			l := integer_list_from_query (q)
			if not l.is_empty then
				Result := l.first
			end
		ensure then
			zero_on_error: error_occurred implies Result = 0
		end

feature -- Status report

	error_occurred: BOOLEAN
			-- Did and error occur in the last database query or command?

feature -- Basic operations

	execute_sql_commands (cmdlist: LINEAR [SQL_COMMAND [ANY]]) is
			-- Execute each SQL command in `cmdlist' within a transaction.
		require
			cmdlist_exists: cmdlist /= Void
		do
			from
				cmdlist.start
			until
				cmdlist.exhausted
			loop
				error_occurred := False
				session.begin_transaction
				debug ("database")
					print ("Executing '" + cmdlist.item.name + "'%N")
				end
				cmdlist.item.execute (Void)
				error_occurred := not cmdlist.item.execution_succeeded
				if error_occurred then
					session.rollback
				else
					session.commit
				end
				cmdlist.forth
			end
		end

	execute_commands (cmdlist: LINEAR [STRING]) is
			-- Execute each SQL command in `cmdlist' within a transaction.
		require
			cmdlist_exists: cmdlist /= Void
		local
			stmt: ECLI_STATEMENT
		do
			from
				cmdlist.start
			until
				cmdlist.exhausted
			loop
				error_occurred := False
				if stmt = Void then
					create stmt.make (session)
				else
					stmt.make (session)
				end
				stmt.set_immediate_execution_mode
				stmt.set_sql (cmdlist.item)
				session.begin_transaction
				debug ("database")
					print ("Executing '" + stmt.sql + "'%N")
				end
				execute_statement (stmt)
				stmt.close
				if error_occurred then
					session.rollback
				else
					session.commit
				end
				cmdlist.forth
			end
		end

	execute_command_array (cmdlist: ARRAY [STRING]) is
			-- Execute each SQL command in `cmdlist' within a transaction.
		require
			cmdlist_exists: cmdlist /= Void
		do
			execute_commands (cmdlist.linear_representation)
		end

	input_statement (query: STRING; value_holders: ARRAY [ECLI_VALUE]):
				ECLI_STATEMENT is
			-- Executed input ECLI_STATEMENT constructed with `query'
			-- and `value_holders'
		do
			error_occurred := False
			create Result.make (session)
			-- No need to prepare:
			Result.set_immediate_execution_mode
			Result.set_sql (query)
			debug ("database")
				print_list (<<"ECLI_TOOLS executing statement:%N",
					Result.sql, "%N">>)
			end
			execute_statement (Result)
			if not error_occurred then
				Result.set_cursor (value_holders)
			end
		end

	execute_statement (stmt: ECLI_STATEMENT) is
			-- Execute `stmt' and set error status if it fails.
		require
			stmt_valid: stmt /= Void and then stmt.sql /= Void and then
				not stmt.sql.is_empty
			no_error: not error_occurred
		do
			stmt.execute
			if not stmt.is_ok then
				last_error := "Database error - execution of statement:%N'" +
					stmt.sql + "' failed:%N" + stmt.cli_state + ", " +
					stmt.diagnostic_message
				debug ("database")
					print (last_error + "%N")
				end
				error_occurred := True
				publish_error ("ERROR: " + last_error)
			end
		ensure
			error_if_not_ok: not stmt.is_ok = error_occurred
		end

feature {NONE} -- Implementation

	session: ECLI_SESSION is
		deferred
		end

	connect_session is
			-- Connect to the database.
		local
			error: BOOLEAN
		do
			if not error then
				error_occurred := False
				session.connect
				if session.is_connected then
					debug ("database")
						io.put_string ("Connected.%N")
					end
				else
					last_error := "Database error - failed to connect: " +
						session.diagnostic_message
					debug ("database")
						print (last_error + "%N")
					end
					error_occurred := True
					publish_error (last_error)
				end
			else
				error_occurred := True
			end
		rescue
			-- Caught exception from first call to `session'.
			error := True
			retry
		end

	cleanup is
		do
			if session.is_connected then session.disconnect end
			if session.is_valid and not session.is_closed then
				session.close
			end
		end

invariant

	session_exists: session /= Void

end
