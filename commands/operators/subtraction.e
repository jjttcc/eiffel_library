indexing
	description: "Binary operator that implements subtraction."

class SUBTRACTION

inherit

	BINARY_OPERATOR

feature

	execute (arg: ANY) is
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
		end

end -- class SUBTRACTION
