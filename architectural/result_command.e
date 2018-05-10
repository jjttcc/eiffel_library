note
	description: "Commands with a result of generic type G";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class RESULT_COMMAND [G] inherit

	COMMAND
		redefine
			status_contents, initialize_from_parent
		end

feature -- Access

	value: G
			-- The result of execution

feature -- Status setting

	initialize_from_parent(p: TREE_NODE)
		do
			parent_implementation := p
		ensure then
			parent = p
		end

feature {NONE} -- Implementation - Hook routine implementations

	status_contents: STRING
		do
			Result := "value: " + value.out
		end

feature {NONE} -- Implementation

	parent_implementation: TREE_NODE

end -- class RESULT_COMMAND
