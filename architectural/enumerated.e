indexing
	description: "Enumerated types"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class ENUMERATED [G] inherit

feature {NONE} -- Initialization

	make (value: G) is
		require
			valid_value: value_set.has(value)
		do
			from
				value_set.start
			until
				value_set.item = value or value_set.after
			loop
				value_set.forth
			end
		ensure
			item_set: item = value
		end

feature -- Access

	item: G is
			-- Integer value of Current
		do
			Result := value_set.item
		end

	name: STRING is
			-- Name of Current
		do
			Result := name_set @ value_set.index
		end

	value_set: LINEAR_SUBSET [G] is
			-- Allowable values
		deferred
		end

	name_set: ARRAY [STRING] is
			-- Names corresponding to `value_set'
		deferred
		end

feature -- Status report

	valid_value (v: G): BOOLEAN is
			-- Is `v' a valid value for this enumeration?
		do
			Result := value_set.has (v)
		end

feature {NONE} -- Implementation

invariant

	name_exists: name /= Void and then not name.is_empty
	sets_exist: value_set /= Void and name_set /= Void
	value_set_not_empty: not value_set.is_empty
	value_name_sets_correspond: value_set.count = name_set.count
	value_in_set: value_set.has (item)
	name_in_set: name_set.has (name)
	name_definition: name = name_set @ value_set.index
	item_valid: valid_value (item)

end
