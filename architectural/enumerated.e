indexing
	description: "Enumerated types"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class ENUMERATED [G -> HASHABLE] inherit

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
			item_index := value_set.index
		ensure
			item_set: item = value
		end

feature -- Access

	item: G is
			-- Integer value of Current
		do
			Result := allowable_values @ item_index
		end

	name: STRING is
			-- Name of Current
		do
			Result := value_name_map @ item
		end

	value_set: LINKED_SET [G] is
			-- Set of allowable values
		deferred
		end

	name_set: CHAIN [STRING] is
			-- Names corresponding to `value_set'
		once
			Result := value_name_map.linear_representation
			Result.compare_objects
		end

feature -- Status report

	valid_value (v: G): BOOLEAN is
			-- Is `v' a valid value for this enumeration?
		do
			Result := value_set.has (v)
		end

feature {NONE} -- Implementation

	value_set_implementation: LINKED_SET [G] is
			-- Implementation of `value_set', for convenience
		local
			i: INTEGER
		do
			create Result.make
			from
				i := allowable_values.lower
			until
				i > allowable_values.upper
			loop
				Result.extend (allowable_values @ i)
				i := i + 1
			end
		end

	value_name_map: HASH_TABLE [STRING, G] is
			-- Mapping of values to names
		deferred
		end

	allowable_values: ARRAY [G] is
			-- Allowable values as an array - used for implementation
			-- efficiency and ease of implementation.
		deferred
		end

	item_index: INTEGER
			-- 

invariant

	name_exists: name /= Void and then not name.is_empty
	sets_exist: value_set /= Void and name_set /= Void
	value_set_not_empty: not value_set.is_empty
	value_name_sets_correspond: value_set.count = name_set.count
	value_in_set: value_set.has (item)
	name_in_set: name_set.has (name)
	name_definition: name /= Void and then equal (name, value_name_map @ item)
	item_valid: valid_value (item)
	name_set_object_comparison: name_set.object_comparison

end
