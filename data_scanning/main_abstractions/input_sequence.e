indexing

	description:
		"A readable (and read-only), iterable sequence of CHARACTERs";
	status: "Copyright 1999 - 2000: Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class BILINEAR_INPUT_SEQUENCE inherit

	BILINEAR [CHARACTER]
		export {NONE}
			has, index_of, search, occurrences, linear_representation
		end

feature -- Access

	name: STRING is
			-- Name of the sequence
		deferred
		end

	last_character: CHARACTER is
			-- Last character read by `read_character'
		deferred
		end

	last_string: STRING is
			-- Last string read
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

feature -- Measurement

	count: INTEGER is
			-- Number of items
		deferred
		end

feature -- Status report

	readable: BOOLEAN is
			-- Is there a current item that may be read?
		deferred
		end;

feature -- Input

	read_real, readreal is
			-- Read a new real.
			-- Make result available in `last_real'.
		require
			is_readable: readable
		deferred
		end;

	read_double, readdouble is
			-- Read a new double.
			-- Make result available in `last_double'.
		require
			is_readable: readable
		deferred
		end;

	read_character, readchar is
			-- Read a new character.
			-- Make result available in `last_character'.
		require
			is_readable: readable
		deferred
		end;

	read_integer, readint is
			-- Read a new integer.
			-- Make result available in `last_integer'.
		require
			is_readable: readable
		deferred
		end;

	read_stream, readstream (nb_char: INTEGER) is
			-- Read a string of at most `nb_char' bound characters
			-- or until end of medium is encountered.
			-- Make result available in `last_string'.
		require
			is_readable: readable
		deferred
		end;

	read_line, readline is
			-- Read characters until a new line or
			-- end of medium.
			-- Make result available in `last_string'.
		require
			is_readable: readable
		deferred
		end;

end -- class BILINEAR_INPUT_SEQUENCE
