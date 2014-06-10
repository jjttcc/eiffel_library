note
	description: "Test of file locking";
	author: "Jim Cochrane"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "Copyright 2004: Jim Cochrane - License to be determined."

class LOCK_TEST inherit

	GENERAL_UTILITIES
		export
			{NONE} all
		end

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make
		local
			file: FILE
			lock: FILE_LOCK
			time: DATE_TIME
		do
			create {PLAIN_TEXT_FILE} file.make ("testlock")
			lock := the_lock (file.name)
			lock.try_lock
			if lock.locked then
				print ("Try lock succeeded.%N")
				lock.unlock
			else
				print ("Try lock failed.%N")
				if lock.error_occurred then
					print (lock.last_error); print ("%N")
				end
			end
			create time.make_now
			print_list (<<"Trying to lock at ", time.out, ".%N">>)
			lock.lock
			check lock.locked end
			time.make_now
			print_list (<<"Obtained lock at ", time.out, ".%N">>)
			file.open_read_append
			time.make_now
			file.put_string (concatenation (<<"Locked at ", time.out, ".%N">>))
			sleep (3)
			time.make_now
			file.put_string (concatenation (<<"Unlocking at ",
				time.out, ".%N">>))
			lock.unlock
			time.make_now
			print_list (<<"Unlocked at ", time.out, ".%N">>)
		end

	the_lock (fname: STRING): FILE_LOCK
		do
			create {BASIC_FILE_LOCK} Result.make (fname)
		end

	sleep (seconds: INTEGER)
		do
			system (concatenation (<<"sleep ", seconds.out>>))
		end

end -- class LOCK_TEST
