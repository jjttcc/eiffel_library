indexing
	description:
		"Value setter with read_value procedure defined to read the next %
		%integer value from the input"
	date: "$Date$";
	revision: "$Revision$"

deferred class INTEGER_SETTER inherit

	VALUE_SETTER

feature {NONE}

	read_value (stream: IO_MEDIUM) is
		do
			stream.read_integer
		end

end -- class INTEGER_SETTER
