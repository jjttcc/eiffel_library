indexing
	description: "Binary operator that implements division."
	date: "$Date$";
	revision: "$Revision$"

class DIVISION

inherit

	BINARY_OPERATOR

feature

	execute (arg: ANY) is
			-- Set value to the result of operand1 / operand2.
		do
			operand1.execute (arg)
			operand2.execute (arg)
			value := operand1.value / operand2.value
		end

feature -- Status report

	execute_postcondition: BOOLEAN is
		do
			Result :=
				rabs (value - (operand1.value / operand2.value)) < epsilon
		ensure then
			division_result_correct:
				rabs (value - (operand1.value / operand2.value)) < epsilon
		end

end -- class DIVISION
