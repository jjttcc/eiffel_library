indexing

	description:
		"A read-only sequence of CHARACTERs";
	status: "Copyright 1999 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class INPUT_SEQUENCE inherit

feature -- Access

	last_character: CHARACTER is
			-- Last character read by `read_character'
		deferred
		end

	last_integer: INTEGER is
			-- Last integer read by `read_integer'
		deferred
		end

	last_real: REAL is
			-- Last real read by `read_real'
		deferred
		end

	last_double: DOUBLE is
			-- Last double read by `read_double'
		deferred
		end

	error_string: STRING
			-- Description of last error

	name: STRING is
			-- Name of the sequence
		deferred
		end

feature -- Status report

	error_occurred: BOOLEAN
			-- Did an error occur in the last operation?

feature -- Status report

	readable: BOOLEAN is
			-- Is there a current item that may be read?
		deferred
		end

feature -- Input

	read_real is
			-- Read a new real.
			-- Make result available in `last_real'.
		require
			is_readable: readable
		deferred
		end

	read_double is
			-- Read a new double.
			-- Make result available in `last_double'.
		require
			is_readable: readable
		deferred
		end

	read_character is
			-- Read a new character.
			-- Make result available in `last_character'.
		require
			is_readable: readable
		deferred
		end

	read_integer is
			-- Read a new integer.
			-- Make result available in `last_integer'.
		require
			is_readable: readable
		deferred
		end

end -- class INPUT_SEQUENCE
