note
	description: "Objects that are nodes in a hierarchical tree structure"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class TREE_NODE inherit

	ANY

feature -- Access

	children: LIST [like Current]
			-- Current's children
		deferred
		ensure
			not_void: Result /= Void
		end

	descendants: LIST [like Current]
			-- All of Current's descendants (excluding Current) - children,
			-- children's children, etc., with duplicates removed
		local
			l: LIST [like Current]
			node_set: LINKED_SET [like Current]
		do
			create {LINKED_LIST [TREE_NODE]} Result.make
			if not descendants_locked then
				lock_descendants
				l := copy_of_children
				create node_set.make
				if descendant_comparison_is_by_objects then
					node_set.compare_objects
				end
				from l.start until l.exhausted loop
					node_set.extend (l.item)
					node_set.append (l.item.descendants)
					l.forth
				end
				Result.append (node_set)
				unlock_descendants
			end
		ensure
			exists: Result /= Void
			current_excluded: not tree_contains_cycle (
				create {HASH_TABLE [BOOLEAN, STRING]}.make (0)) implies
				not Result.has (Current)
			same_lock_state: descendants_locked = old descendants_locked
		end

	name: STRING
			-- Current's name
		do
			-- Redefine as needed.
			Result := ""
		end

feature -- Status report

	status: STRING
			-- Status of Current (not its desdendants) - for debugging
		do
			Result := status_tag + status_contents
		ensure
			Result_exists: Result /= Void
		end

	status_report: STRING
			-- Report on the status of Current and its descendants -
			-- for debugging
		do
			Result := report (0, agent {TREE_NODE}.status)
		end

	node_names: STRING
			-- The name of this node and all descendants, formatted
			-- according to the current tree hierarchy
		do
			Result := report (0, agent {TREE_NODE}.name)
		end

	tree_contains_cycle (visited: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
			-- Does the tree with Current as the root contain a cycle?
		require
			arg_exists: visited /= Void
		local
			current_tag: STRING
			l: LIST [like Current]
		do
			current_tag := out
			-- If Current has already been visited for this cycle check,
			-- then there is a cycle:
			Result := visited @ current_tag
			if not Result then
				visited.force (True, current_tag)
				from
					l := children
					l.start
				until
					Result or else l.exhausted
				loop
					Result := l.item.tree_contains_cycle (visited)
					l.forth
				end
				visited.force (False, current_tag)
			end
		ensure
			true_if_already_visited: old (visited @ out) implies Result
		end

feature {NONE} -- Implementation - Hook routines

	copy_of_children: LIST [like Current]
			-- Copy of `children' - Default to a reference to `children'.
			-- Redefine to use clone or deep_clone if needed.
		do
			Result := children
		ensure
			result_exists: Result /= Void
		end

	descendant_comparison_is_by_objects: BOOLEAN
			-- Should object_comparison be used (as opposed to reference
			-- comparison) to remove duplicates from `descendants'?
		do
			-- Default to False - Redefine if object comparsion is needed.
		end

	status_tag: STRING
		do
			-- Default status tag - redefine as needed.
			if name.is_empty then
				Result := alternate_status_tag
			else
				Result := name + ": "
			end
		end

	status_contents: STRING
		do
			-- Default status contents - redefine as needed.
			Result := "OK"
		end

	alternate_status_tag: STRING
			-- Alternate status tag if `name' is empty
		do
			-- Redefine as needed.
			Result := "status: "
		end

	empty_report_string: STRING
			-- String to substitute for an empty report result
		do
			Result := ""
		end

	descendants_locked: BOOLEAN
			-- Implementation state to prevent infinite calls to descendants
			-- when Current is part of a cycle - Redefine appropriately,
			-- along with `lock_descendants' and `unlock_descendants',
			-- if this functionality is required.
		do
			Result := False
		end

	lock_descendants
		do
		end

	unlock_descendants
		do
		end

feature {TREE_NODE} -- Implementation

	report (indent_size: INTEGER;
		report_function: FUNCTION [ANY, TUPLE [], STRING]): STRING
			-- Information about Current with hierarchical indenting, using
			-- `report_function' for the report contents
		local
			spaces: STRING
			chl: LIST [TREE_NODE]
			child_indent: INTEGER
			i: INTEGER
		do
			create spaces.make (0)
			from i := 1 until i > indent_size loop
				spaces.extend (' ')
				i := i + 1
			end
			-- Ensure that Current is the target for the call
			-- of `report_function'.
			report_function.set_operands ([Current])
			report_function.apply
			if
				report_function.last_result /= Void and then
				not report_function.last_result.is_empty
			then
				Result := spaces + report_function.last_result + "%N"
			else
				Result := empty_report_string
			end
			child_indent := indent_size + Indent_increment
			from
				chl := children
				chl.start
			until
				chl.exhausted
			loop
				Result := Result + chl.item.report (child_indent,
					report_function)
				chl.forth
			end
		end

feature {NONE} -- Implementation - constants

	Indent_increment: INTEGER = 3

invariant

	children_exist: children /= Void
	descendants_exist: descendants /= Void
	children_and_descendants_correspond: not descendants_locked implies
		children.is_empty = descendants.is_empty
	name_not_void: name /= Void

end
