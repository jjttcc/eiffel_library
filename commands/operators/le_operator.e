indexing
	description: "Less-than-or-equal-to operator"
	date: "$Date$";
	revision: "$Revision$"

class LE_OPERATOR [G->COMPARABLE] inherit

	BOOLEAN_OPERATOR [G]

feature

	execute (arg: ANY) is
		do
			value := operand1 <= operand2
		ensure then
			value_le: value = (operand1 <= operand2)
		end

end -- class LE_OPERATOR
