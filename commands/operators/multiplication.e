indexing
	description: "Binary numeric operator that implements multiplication"
	status: "Copyright 1998 Jim Cochrane and others, see file forum.txt"
	date: "$Date$";
	revision: "$Revision$"

class MULTIPLICATION

inherit

	BINARY_NUMERIC_OPERATOR

creation

	make

feature

	execute (arg: ANY) is
			-- Set value to the result of operand1 * operand2.
		do
			operand1.execute (arg)
			operand2.execute (arg)
			value := operand1.value * operand2.value
		ensure then
			multiplication_result_correct:
				rabs (value - (operand1.value * operand2.value)) < epsilon
		end

end -- class MULTIPLICATION
