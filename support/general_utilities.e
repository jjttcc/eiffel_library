indexing
	description: "General utility routines"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	GENERAL_UTILITIES

feature -- Basic operations

	concatenation (a: ARRAY [ANY]): STRING is
			-- A string containing a concatenation of all elements of `a'
		require
			not_void: a /= Void
		local
			i: INTEGER
		do
			create Result.make (0)
			from
				i := 1
			until
				i = a.count + 1
			loop
				if a @ i /= Void then
					Result.append ((a @ i).out)
				end
				i := i + 1
			end
		ensure
			not_void: Result /= Void
		end

	print_list (l: ARRAY [ANY]) is
			-- Print all members of `l'.
		require
			not_void: l /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i = l.count + 1
			loop
				if l @ i /= Void then
					print (l @ i)
				end
				i := i + 1
			end
		end

	print_actual_list (l: LIST [ANY]; newlines: BOOLEAN) is
			-- Print all members of `l'.
			-- If `newlines' a new line is printed after each element.
		require
			not_void: l /= Void
		local
			i: INTEGER
		do
			from
				l.start
			until
				l.exhausted
			loop
				if l.item /= Void then
					print (l.item)
					if newlines then print ("%N") end
				end
				l.forth
			end
		end

	log_error (msg: STRING) is
			-- Log `msg' as an error.
		require
			not_void: msg /= Void
		do
			io.error.put_string (msg)
		end

	log_errors (list: ARRAY [ANY]) is
			-- Log `list' of error messages.
		require
			not_void: list /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i = list.count + 1
			loop
				if list @ i /= Void then
					log_error ((list @ i).out)
				end
				i := i + 1
			end
		end

	check_objects (a: ARRAY [ANY]; descriptions: ARRAY [STRING];
		ok: FUNCTION [ANY, TUPLE [ANY], BOOLEAN]; handler:
		PROCEDURE [ANY, TUPLE [LIST [STRING]]];
		proc_arg: ANY; msg: STRING) is
			-- For each "i" in `a.lower' to `a.upper', if a @ i is not `ok',
			-- insert descriptions @ i into a list and execute `handler'
			-- on the list.  `proc_arg' is an additional, optional (can
			-- be Void) argument to `handler' and `msg' is an optional
			-- error description to pass on to `handler'.
		require
			valid_args: a /= Void and descriptions /= Void and
				a.count = descriptions.count
			same_ranges: a.lower = descriptions.lower and
				a.upper = descriptions.upper
		local
			i: INTEGER
			invalid_items: LINKED_LIST [STRING]
		do
			from
				create invalid_items.make
				i := a.lower
			until
				i = a.upper + 1
			loop
				--!!!When ready, change eval to item.
				if not ok.eval ([a @ i]) then
					invalid_items.extend (descriptions @ i)
				end
				i := i + 1
			end
			if not invalid_items.is_empty then
				handler.call ([invalid_items, proc_arg])
			end
		end

end -- class GENERAL_UTILITIES
