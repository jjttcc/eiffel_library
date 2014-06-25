note
	description:
		"Value setter with read_value procedure defined to read the next %
		%string value from the input"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class STRING_SETTER [G] inherit

	VALUE_SETTER [G]

feature {NONE}

	read_value (stream: INPUT_SEQUENCE)
		do
			stream.read_string
		end

end -- class STRING_SETTER
