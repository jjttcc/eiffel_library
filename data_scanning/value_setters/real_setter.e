note
	description:
		"Value setter with read_value procedure defined to read the next %
		%real value from the input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class REAL_SETTER [G] inherit

	VALUE_SETTER [G]

	MATH_CONSTANTS

	GENERAL_UTILITIES
		export {NONE}
			all
		end

feature {NONE}

	read_value (stream: INPUT_SEQUENCE)
		do
			stream.read_double
		end

	handle_le_0_error (field_name: STRING)
			-- Handle case where input value <= 0.
		do
			handle_input_error (concatenation (<<field_name,
				" field is less than or equal to 0">>), Void)
			unrecoverable_error := True
		ensure
			unrecoverable: unrecoverable_error = True
		end

end -- class REAL_SETTER
