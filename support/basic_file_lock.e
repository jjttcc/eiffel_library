indexing
	description: "Basic file locking implementation based on the creation %
		%and deletion of an external file";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2000: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class BASIC_FILE_LOCK inherit

	FILE_LOCK
		redefine
			make
		end

	EXCEPTIONS
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make (fpath: STRING) is
		do
			Precursor (fpath)
			set_lock_file_name
		end

feature -- Basic operations

	try_lock is
		local
			fname: ANY
		do
			fname := lock_file_name.to_c
			if try_to_open ($fname, False_value) = -1 then
				locked := false
				if last_op_failed then
					error_occurred := true
					set_last_error ("Error occurred trying to lock file: ")
				end
			else
				locked := true
			end
		end

	lock is
		local
			fname: ANY
		do
			fname := lock_file_name.to_c
			if try_to_open ($fname, True_value) = -1 then
				error_occurred := true
				set_last_error ("Error occurred while locking file: ")
				raise (last_error)
			end
			locked := true
		end

	unlock is
		local
			fname: ANY
		do
			fname := lock_file_name.to_c
			if remove_file ($fname) = -1 then
				error_occurred := true
				set_last_error ("Error occurred trying to unlock item: ")
				last_error.append (".%N(Could not remove lock file:%N")
				last_error.append (lock_file_name)
				last_error.append (".)%N")
				raise (last_error)
			end
			locked := false
		end

feature {NONE} -- Implementation

	try_to_open (fname : POINTER; wait: INTEGER): INTEGER is
		external
			 "C"
		end

	remove_file (fname : POINTER): INTEGER is
		external
			 "C"
		end

	error_on_last_operation: INTEGER is
		external
			 "C"
		end

	last_error: STRING

	set_last_error (pre_fix: STRING) is
		do
			create last_error.make (0)
			last_error.from_c (last_c_error)
			if pre_fix /= Void and not pre_fix.empty then
				last_error.prepend (pre_fix)
			end
		end

	last_c_error: POINTER is
		external
			 "C"
		end

	False_value: INTEGER is 0

	True_value: INTEGER is 1

	lock_file_name: STRING

	set_lock_file_name is
		local
			oe: expanded OPERATING_ENVIRONMENT
			i: INTEGER
		do
			lock_file_name := clone (file_path)
			lock_file_name.insert (".", lock_file_name.last_index_of (
				oe.Directory_separator, lock_file_name.count) + 1)
			lock_file_name.append (".lock")
		end

	last_op_failed: BOOLEAN is
		do
			Result := error_on_last_operation /= 0
		end

end -- class BASIC_FILE_LOCK
