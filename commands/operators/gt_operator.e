indexing
	description: "Greater-than operator"
	date: "$Date$";
	revision: "$Revision$"

class GT_OPERATOR [G->COMPARABLE] inherit

	BOOLEAN_OPERATOR [G]

feature

	execute (arg: ANY) is
		do
			value := operand1 > operand2
		ensure then
			value_gt: value = (operand1 > operand2)
		end

end -- class GT_OPERATOR
