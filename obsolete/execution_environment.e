note
	description: "Work-around for ISE Eiffel 4.4 bug in EXECUTION_ENVIRONMENT"
	note1: "@@Check if this bug has been fixed in 5.1."
	author: "Eirik Mangseth"
	date: "$Date$"
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class EXECUTION_ENVIRONMENT inherit

	EXECUTION_ENVIRONMENT
		redefine
			get, eif_getenv
		end

feature

	get (s: STRING): STRING is 
		-- Value of `s' if it is an environment variable and has been set
		-- void otherwise. 
	require else
		s_exists: s /= Void 
	local 
		ext			: ANY
		c_string	: POINTER
	do 
		ext := s.to_c 
		c_string := eif_getenv($ext) 
		if c_string /= default_pointer then
			create Result.make (0) 
			Result.from_c (c_string) 
		end
	end 

feature {NONE}

	eif_getenv (s : POINTER): POINTER is 
		-- Value of environment variable `s' 
		external
			 "C | <stdlib.h>" 
		alias
			"getenv"
		end

end
