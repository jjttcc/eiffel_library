note
	description:
		"Value setter with read_value procedure defined to read the next %
		%integer value from the input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class INTEGER_SETTER [G] inherit

	VALUE_SETTER [G]

feature {NONE}

	read_value (stream: INPUT_SEQUENCE)
		do
			stream.read_integer
		end

end -- class INTEGER_SETTER
