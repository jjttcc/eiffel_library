indexing
	description: "General utility routines"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class

	GENERAL_UTILITIES

feature -- String manipulation

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

	list_concatenation (l: LIST [ANY]; suffix: STRING): STRING is
			-- A string containing a concatenation of all elements of `l',
			-- with `suffix', if it is not empty, appended to each element
		require
			not_void: l /= Void
		local
			s: STRING
		do
			from
				Result := ""
				s := ""
				if suffix /= Void and then not suffix.is_empty then
					s := suffix
				end
				l.start
			until
				l.exhausted
			loop
				if l.item /= Void then
					Result.append (l.item.out + s)
				end
				l.forth
			end
		ensure
			not_void: Result /= Void
			empty_if_empty: l.is_empty implies Result.is_empty
		end

	replace_token_all (target, token, new_value: STRING;
		start_delimiter, end_delimiter: CHARACTER) is
			-- Replace in `target' all occurrences of
			-- `start_delimiter' + `token' + `end_delimiter'
			-- with `new_value'.
		require
			args_exist: target /= Void and token /= Void and new_value /= Void
		local
			replacement: STRING
		do
			replacement := clone (token)
			replacement.prepend_character (start_delimiter)
			replacement.append_character (end_delimiter)
			target.replace_substring_all (replacement, new_value)
		end

	replace_tokens (target: STRING; tokens: ARRAY [STRING]; values:
		ARRAY [STRING]; token_start, token_end: CHARACTER) is
			-- Replace all occurrences of `tokens' in `target' with
			-- the respective specified `values', where each token
			-- begins with `token_start' and ends with `token_end'.
		require
			args_exists: target /= Void and tokens /= Void and values /= Void
			same_number_of_tokens_and_values: tokens.count = values.count
			same_index_settings: tokens.lower = values.lower and
				tokens.upper = values.upper
		local
			i: INTEGER
		do
			from
				i := tokens.lower
			until
				i = tokens.upper + 1
			loop
				replace_token_all (target, tokens @ i, values @ i,
					token_start, token_end)
				i := i + 1
			end
		end

	merged (l: LIST [STRING]; separator: STRING): STRING is
			-- Concatenation of `l' into a string whose elements are
			-- separated with `separator'
		require
			args_exist: l /= Void and separator /= Void
		do
			if not l.is_empty then
				from
					l.start
					Result := clone (l.item)
					l.forth
				until
					l.exhausted
				loop
					Result.append (separator + l.item)
					l.forth
				end
			else
				Result := ""
			end
		ensure
			exists: Result /= Void
			empty_if_l_empty: l.is_empty implies Result.is_empty
			no_separator_at_end: not Result.is_empty implies
				Result.item (Result.count) = l.last.item (l.last.count)
		end

	split_in_two (s: STRING; separator: CHARACTER): CHAIN [STRING] is
			-- The result of splitting `s' in two at the point of the
			-- first occurrence in `s' of `separator', where the component
			-- in `s' to the left of `separator' is placed in Result @ 1
			-- and the component in `s' to the right of `separator' is
			-- placed in Result @ 2
		local
			i: INTEGER
			l: LINKED_LIST [STRING]
		do
			create l.make
			if s.has (separator) then
				i := s.index_of (separator, 1)
				l.extend (s.substring (1, i - 1))
				l.extend (s.substring (i + 1, s.count))
			else
				l.extend (clone (s))
			end
			Result := l
		ensure
			result_exists: Result /= Void
			no_more_than_2: Result.count <= 2
			no_less_than_1: Result.count >= 1
			two_if_s_has_separator: s.has (separator) = (Result.count = 2)
			one_if_not_s_has_separator: not s.has (separator) =
				(Result.count = 1)
		end

feature -- Logging

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
			-- If `msg' is longer than `Maximum_message_length', only
			-- the first `Maximum_message_length' characters of `msg'
			-- will be logged.
		local
			s: STRING
		do
			if msg /= Void then
				s := msg
				if msg.count > Maximum_message_length then
					s := msg.substring (1, Maximum_message_length) + "%N"
				end
				io.error.put_string (s)
			end
		end

	log_errors (list: ARRAY [ANY]) is
			-- Log `list' of error messages.  If any element of `list' is
			-- longer than `Maximum_message_length', only the first
			-- `Maximum_message_length' characters of that element will
			-- be logged.
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

	log_error_list (list: LIST [ANY]) is
			-- Log actual LIST of error messages.  If any element of `list' is
			-- longer than `Maximum_message_length', only the first
			-- `Maximum_message_length' characters of that element will
			-- be logged.
		require
			not_void: list /= Void
		do
			list.do_all (agent log_error)
		end

	log_information (msg: STRING) is
			-- Log `msg' as (non-error) information.
		require
			not_void: msg /= Void
		do
			io.print (msg)
		end

feature -- Miscellaneous

	microsleep (seconds, microseconds: INTEGER) is
		external
			 "C"
		end

	deep_copy_list (target, source: LIST [ANY]) is
			-- Do a deep copy from `source' to `target' - work-around
			-- for apparent bug in LINKED_LIST's deep_copy.
		local
			temp: like target
		do
			temp := deep_clone (source)
			target.copy (temp)
		end

	check_objects (a: ARRAY [ANY]; descriptions: ARRAY [STRING];
		ok: FUNCTION [ANY, TUPLE [ANY], BOOLEAN]; handler:
		PROCEDURE [ANY, TUPLE [LINEAR [STRING]]];
		proc_arg: ANY; info: ANY) is
			-- For each "i" in `a.lower' to `a.upper', if a @ i is not `ok',
			-- insert descriptions @ i into a list and execute `handler'
			-- on the list.  `proc_arg' is an additional, optional (can
			-- be Void) argument to `handler' and `info' is an optional
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
				if not ok.item ([a @ i]) then
					invalid_items.extend (descriptions @ i)
				end
				i := i + 1
			end
			if not invalid_items.is_empty then
				handler.call ([invalid_items, proc_arg, info])
			end
		end

	is_not_void (o: ANY): BOOLEAN is
			-- Is `o' Void?  (Candidate `ok' function for `check_objects')
		do
			Result := o /= Void
		end

	is_void (o: ANY): BOOLEAN is
			-- Is `o' Void?  (Candidate `ok' function for `check_objects')
		do
			Result := o = Void
		end

	non_empty_string (s: STRING): BOOLEAN is
			-- Is `s' not empty?
		do
			Result := s /= Void and then not s.is_empty
		ensure
			Result = (s /= Void and then not s.is_empty)
		end

	string_boolean_pair (s: STRING; b: BOOLEAN): PAIR [STRING, BOOLEAN] is
			-- A PAIR with `s' as the left item and `b' as the right item
		do
			create Result.make (s, b)
		ensure
			result_exists: Result /= Void
			s_left_b_right: Result.left = s and Result.right = b
		end

feature -- List manipulation

	append_string_boolean_pair (l: SEQUENCE [PAIR [STRING, BOOLEAN]];
		s: STRING; b: BOOLEAN) is
			-- Wrap `s' and `b' into a PAIR and append the pair to `l'.
		require
			l_exists: l /= Void
		do
			l.extend (string_boolean_pair (s, b))
		end

feature -- Constants

	Maximum_message_length: INTEGER is
			-- Maximum length of messages to be logged
		once
			Result := 1000
		end

end -- class GENERAL_UTILITIES
