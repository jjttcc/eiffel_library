note
	description: "General user-validation utilities"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	USER_VALIDATION

feature -- Access

	valid_email_address (addr: STRING): BOOLEAN
			-- Is `addr' a valid email address?
		local
			regex: expanded REGULAR_EXPRESSION_UTILITIES
		do
			Result := addr /= Void and then not addr.is_empty and then
				regex.match(email_address_pattern, addr)
		end

feature {NONE} -- Implementation

	email_address_pattern: STRING
		"^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$"

end
