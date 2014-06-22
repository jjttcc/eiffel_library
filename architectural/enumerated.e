note
	description: "Enumerated types"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class ENUMERATED [G -> HASHABLE] inherit

	ANY
		redefine
			out
		end

feature {ENUMERATED} -- Initialization

	make (value: G)
		require
			valid_value: valid_value (value)
		do
			value_set := value_set_implementation
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

feature {NONE} -- Initialization

	new_instance (value: G): like Current
			-- A new instance of this 'ENUMERATED' with the specified `value'
		do
			Result := Current.twin
			Result.make (value)
		end

feature -- Access

	item: G
			-- Integer value of Current
		do
			Result := allowable_values @ item_index
		end

	name: STRING
			-- Name of Current
		do
			Result := value_name_map @ item
		end

	value_set: LINKED_SET [G]
			-- Set of allowable values

	name_set: CHAIN [STRING]
			-- Names corresponding to `value_set'
		do
			Result := value_name_map.linear_representation
			Result.compare_objects
		end

	all_members: LINKED_SET [ENUMERATED [G]]
			-- All members of the set of allowed values for this enumeration
		local
			values: LINKED_SET [G]
		do
			values := value_set
			create Result.make
			from
				values.start
			until
				values.exhausted
			loop
				Result.extend (new_instance (values.item))
				values.forth
			end
		ensure
			exists: Result /= Void
			valid_count: Result.count = value_set.count
		end

	out: STRING
		do
			Result := ""
			from
				value_set.start
			until
				value_set.exhausted
			loop
				Result := Result + value_set.item.out + " (" +
					value_name_map @ value_set.item + ")"
				value_set.forth
				if not value_set.exhausted then
					Result := Result + ", "
				end
			end
		end

feature -- Status report

	valid_value (v: G): BOOLEAN
			-- Is `v' a valid value for this enumeration?
		do
			Result := allowable_values.has (v)
		end

feature {NONE} -- Implementation

	value_set_implementation: LINKED_SET [G]
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

	value_name_map: HASH_TABLE [STRING, G]
			-- Mapping of values to names
		deferred
		end

	allowable_values: ARRAY [G]
			-- Allowable values as an array - used for implementation
			-- efficiency and ease of implementation.
		do
			if allowable_values_implementation = Void then
				allowable_values_implementation := initial_allowable_values
			end
			Result := allowable_values_implementation
		end

	item_index: INTEGER
			-- Index of the enumeration value

feature {NONE} -- Initialization utilities

	initial_allowable_values: ARRAY [G]
			-- Used to initialize `allowable_values'.
		deferred
		ensure
			exists: Result /= Void
		end

	allowable_values_implementation: ARRAY [G]

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
	allowable_values_exist: allowable_values /= Void
	map_exists: value_name_map /= Void

end
