indexing
	description: "Enumerated types"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class ENUMERATED inherit

feature {NONE} -- Initialization

	make (the_value: INTEGER) is
		require
			valid_value: value_set.has(the_value)
		do
			value_index := the_value
		ensure
			item_set: item = the_value
		end

feature -- Access

	item: INTEGER is
			-- Integer value of Current
		do
			Result := value_set @ value_index
		end

	name: STRING is
			-- Name of Current
		do
			Result := name_set @ value_index
		end

	value_set: INTEGER_INTERVAL is
			-- Allowable values
		deferred
		end

	name_set: ARRAY [STRING] is
			-- Names corresponding to `value_set'
		deferred
		end

feature -- Status report

	valid_value (v: INTEGER): BOOLEAN is
			-- Is `v' a valid value for this enumeration?
		do
			Result := value_set.has (v)
		end

feature {NONE} -- Implementation

	value_index: INTEGER
			-- Index identifying the value, from `value_set' for Current

invariant

	name_exists: name /= Void and then not name.is_empty
	sets_exist: value_set /= Void and name_set /= Void
	name_value_implementation: item = value_set @ value_index and
		name = name_set @ value_index
	value_name_sets_correspond: value_set.lower = name_set.lower and
		value_set.upper = name_set.upper
	value_in_set: item >= value_set.lower and item <= value_set.upper
	name_in_set: name_set.has (name)
	item_valid: valid_value (item)

end
