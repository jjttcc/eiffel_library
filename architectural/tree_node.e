indexing
	description: "Objects that are nodes in a hierarchical tree structure"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class 

	TREE_NODE

feature -- Access

	children: LIST [like Current] is
			-- Current's children
		deferred
		end

	descendants: LIST [like Current] is
			-- All of this command's descendants - children, children's
			-- children, etc., with duplicates removed
		local
			l: LIST [like Current]
			node_set: LINKED_SET [like Current]
		do
			create {LINKED_LIST [TREE_NODE]} Result.make
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
		end

	name: STRING is
			-- Current's name
		do
			-- Redefine as needed.
			Result := ""
		end

feature -- Status report

	status: STRING is
			-- Status of Current (not its desdendants) - for debugging
		do
			Result := status_tag + status_contents
		ensure
			Result_exists: Result /= Void
		end

	status_report: STRING is
			-- Report on the status of Current and its descendants -
			-- for debugging
		do
			Result := report (0, agent {TREE_NODE}.status)
		end

	node_names: STRING is
			-- The name of this node and all descendants, formatted
			-- according to the current tree hierarchy
		do
			Result := report (0, agent {TREE_NODE}.name)
		end

feature {NONE} -- Implementation - Hook routines

	copy_of_children: LIST [like Current] is
			-- Copy of `children' - Default to a reference to `children'.
			-- Redefine to use clone or deep_clone if needed.
		do
			Result := children
		ensure
			result_exists: Result /= Void
		end

	descendant_comparison_is_by_objects: BOOLEAN is
			-- Should object_comparison be used (as opposed to reference
			-- comparison) to remove duplicates from `descendants'?
		do
			-- Default to False - Redefine if object comparsion is needed.
		end

	status_tag: STRING is
		do
			-- Default status tag - redefine as needed.
			if name.is_empty then
				Result := alternate_status_tag
			else
				Result := name + ": "
			end
		end

	status_contents: STRING is
		do
			-- Default status contents - redefine as needed.
			Result := "OK"
		end

	alternate_status_tag: STRING is
			-- Alternate status tag if `name' is empty
		do
			-- Redefine as needed.
			Result := "status: "
		end

	empty_report_string: STRING is
			-- String to substitute for an empty report result
		do
			Result := ""
		end

feature {TREE_NODE} -- Implementation

	report (indent_size: INTEGER;
		report_function: FUNCTION [ANY, TUPLE [], STRING]): STRING is
			-- Information about Current with hierarchical indenting, using
			-- `report_function' for the report contents
		local
			spaces: STRING
			chl: LIST [TREE_NODE]
			child_indent: INTEGER
			i: INTEGER
			tuple: TUPLE
		do
			create spaces.make (0)
			from i := 1 until i > indent_size loop
				spaces.extend (' ')
				i := i + 1
			end
			-- Ensure that Current is the target for the call
			-- of `report_function'.
			create tuple.make; tuple.make_from_array (<<Current>>)
			report_function.set_operands (tuple)
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

	Indent_increment: INTEGER is 3

invariant

	children_exist: children /= Void
	descendants_exist: descendants /= Void
	children_and_descendants_correspond: children.is_empty =
		descendants.is_empty
	name_not_void: name /= Void

end
