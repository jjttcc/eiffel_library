note

	description:
		"A read-only sequence of CHARACTERs";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class INPUT_SEQUENCE inherit

feature -- Access

	last_character: CHARACTER
			-- Last character read by `read_character'
		deferred
		end

	last_integer: INTEGER
			-- Last integer read by `read_integer'
		deferred
		end

	last_real: REAL
			-- Last real read by `read_real'
		deferred
		end

	last_double: DOUBLE
			-- Last double read by `read_double'
		deferred
		end

	last_string: STRING
			-- Last string read by `read_string'
		deferred
		end

	last_date: DATE
			-- Last date read by `read_date'
		deferred
		end

	error_string: STRING
			-- Description of last error

	name: STRING
			-- Name of the sequence
		deferred
		end

feature -- Status report

	error_occurred: BOOLEAN
			-- Did an error occur in the last operation?

feature -- Status report

	readable: BOOLEAN
			-- Is there a current item that may be read?
		deferred
		end

feature -- Input

	read_real
			-- Read a new real.
			-- Make result available in `last_real'.
		require
			is_readable: readable
		deferred
		end

	read_double
			-- Read a new double.
			-- Make result available in `last_double'.
		require
			is_readable: readable
		deferred
		end

	read_character
			-- Read a new character.
			-- Make result available in `last_character'.
		require
			is_readable: readable
		deferred
		end

	read_integer
			-- Read a new integer.
			-- Make result available in `last_integer'.
		require
			is_readable: readable
		deferred
		end

	read_string
			-- Read a new string.
			-- Make result available in `last_string'.
		require
			is_readable: readable
		deferred
		end

	read_date
			-- Read a new date.
			-- Make result available in `last_date'.
		require
			is_readable: readable
		deferred
		end

end -- class INPUT_SEQUENCE
