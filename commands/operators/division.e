indexing
	description: "Binary operator that implements division."

class DIVISION

inherit

	BINARY_OPERATOR

feature

	execute (arg: ANY) is
		do
			operand1.execute (arg)
			operand2.execute (arg)
			value := operand1.value / operand2.value
			debug
				io.put_string ("division: operand values: ")
				io.put_real (operand1.value)
				io.put_string (", ")
				io.put_real (operand2.value)
				io.put_string ("%Ndivision: value in percent: ")
				io.put_real (value * 100)
				io.put_string ("%N")
			end
		end

end -- class DIVISION
