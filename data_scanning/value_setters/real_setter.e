indexing
	description:
		"Value setter with read_value procedure defined to read the next %
		%real value from the input"
	status: "Copyright 1998 - 2000: Jim Cochrane and others; see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

deferred class REAL_SETTER inherit

	VALUE_SETTER

	MATH_CONSTANTS

	GENERAL_UTILITIES
		export {NONE}
			all
		end

feature {NONE}

	read_value (stream: INPUT_SEQUENCE) is
		do
			stream.read_real
		end

	handle_le_0_error (field_name: STRING) is
			-- Handle case where input value <= 0.
		do
			handle_input_error (concatenation (<<field_name,
				" field is less than or equal to 0">>), Void)
			unrecoverable_error := true
		ensure
			unrecoverable: unrecoverable_error = true
		end

end -- class REAL_SETTER
