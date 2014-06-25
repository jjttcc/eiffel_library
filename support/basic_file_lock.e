note
	description: "Basic file locking implementation based on the creation %
		%and deletion of an external file";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class BASIC_FILE_LOCK inherit

	FILE_LOCK
		redefine
			make
		end

	GENERAL_UTILITIES
		export
			{NONE} all
		end

	EXCEPTIONS
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make (fpath: STRING)
		do
			Precursor (fpath)
			set_lock_file_name
		end

feature -- Basic operations

	try_lock
		local
			fname: ANY
			suffix: STRING
		do
			fname := lock_file_name.to_c
			lock_file_descriptor := try_to_open ($fname, False_value)
			if lock_file_descriptor = -1 then
				locked := False
				if last_op_failed then
					if open_file_exists /= 0 then
						suffix := concatenation (<<"%N(Lock file ",
							lock_file_name, " exists.)">>)
					else
						suffix := Void
					end
					error_occurred := True
					set_last_error ("Error occurred trying to lock file: ",
						suffix)
				end
			else
				locked := True
			end
		end

	lock
		local
			fname: ANY
		do
			fname := lock_file_name.to_c
			lock_file_descriptor := try_to_open ($fname, True_value)
			if lock_file_descriptor = -1 then
				error_occurred := True
				set_last_error ("Error occurred while locking file: ", Void)
				raise (last_error)
			end
			locked := True
		end

	unlock
		local
			fname: ANY
			i: INTEGER
		do
			fname := lock_file_name.to_c
			i := close_file (lock_file_descriptor)
			if i = -1 then
			end
			if remove_file ($fname) = -1 then
				error_occurred := True
				set_last_error ("Error occurred trying to unlock item: ", Void)
				last_error.append (".%N(Could not remove lock file:%N")
				last_error.append (lock_file_name)
				last_error.append (".)%N")
				raise (last_error)
			end
			locked := False
		end

feature {NONE} -- Implementation

	try_to_open (fname : POINTER; wait: INTEGER): INTEGER
		external
			 "C"
		end

	remove_file (fname : POINTER): INTEGER
		external
			 "C"
		end

	close_file (fdescriptor : INTEGER): INTEGER
		external
			 "C"
		end

	open_file_exists: INTEGER
		external
			 "C"
		end

	error_on_last_operation: INTEGER
		external
			 "C"
		end

	last_error: STRING

	set_last_error (pre_fix, suffix: STRING)
		do
			create last_error.make (0)
			last_error.from_c (last_c_error)
			if pre_fix /= Void and not pre_fix.is_empty then
				last_error.prepend (pre_fix)
			end
			if suffix /= Void and not suffix.is_empty then
				last_error.append (suffix)
			end
		end

	last_c_error: POINTER
		external
			 "C"
		end

	False_value: INTEGER = 0

	True_value: INTEGER = 1

	lock_file_name: STRING

	lock_file_descriptor: INTEGER

	set_lock_file_name
		local
			oe: expanded OPERATING_ENVIRONMENT
		do
			lock_file_name := file_path.twin
			lock_file_name.insert_string (".", lock_file_name.last_index_of (
				oe.Directory_separator, lock_file_name.count) + 1)
			lock_file_name.append (".lock")
		end

	last_op_failed: BOOLEAN
		do
			Result := error_on_last_operation /= 0
		end

end -- class BASIC_FILE_LOCK
