indexing
	description: "Binary operator that implements subtraction."
	date: "$Date$";
	revision: "$Revision$"

class SUBTRACTION

inherit

	BINARY_OPERATOR

feature

	execute (arg: ANY) is
			-- Set value to the result of operand1 - operand2
		do
			operand1.execute (arg)
			operand2.execute (arg)
			value := operand1.value - operand2.value
			debug
				io.put_string ("subtraction: operand values: ")
				io.put_real (operand1.value)
				io.put_string (", ")
				io.put_real (operand2.value)
				io.put_string ("%Nsubtraction: value: ")
				io.put_real (value)
				io.put_string ("%N")
			end
		ensure then
			value = operand1.value - operand2.value
			subtraction_correct:
				rabs (value - (operand1.value - operand2.value)) < epsilon
		end

end -- class SUBTRACTION
