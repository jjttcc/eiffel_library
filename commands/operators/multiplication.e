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
			-- Execute `operand1' and `operand2' and set `value' to the
			-- product of their resulting values.
		local
			op1value: REAL
		do
			operand1.execute (arg)
			-- Retrieve result in case the following statement changes it.
			op1value := operand1.value
			operand2.execute (arg)
			value := op1value * operand2.value
		end

end -- class MULTIPLICATION
