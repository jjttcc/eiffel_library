indexing
	description: "Equal-to operator"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class EQ_OPERATOR [G->COMPARABLE] inherit

	BOOLEAN_OPERATOR [G]

feature

	execute (arg: ANY) is
		do
			value := operand1 = operand2
		ensure then
			value_eq: value = (operand1 = operand2)
		end

end -- class EQ_OPERATOR
