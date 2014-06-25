note
	description: "General user-validation utilities"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

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
