indexing
	description: "Work-around for ISE Eiffel 4.4 bug"
	date: "$Date$"

class MAS_EXECUTION_ENVIRONMENT inherit

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
			!!Result.make (0) 
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

end --class MAS_EXECUTION_ENVIRONMENT