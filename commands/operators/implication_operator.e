indexing
	description: "Boolean 'implication' (=>) operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class IMPLICATION_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]
		redefine
			execute -- Take advantage of "implication" optimization.
		end

creation

	make

feature -- Basic operations

	execute (arg: ANY) is
			-- Optimized to not execute operand2 if the result from
			-- operand1 is False.
			-- A system exception may occur (most likely caused by division
			-- by 0) during execution of this feature.  In this case,
			-- the exception is caught and `value' is set to a default.
		local
			exception_occurred: BOOLEAN
		do
			if not exception_occurred then
				operand1.execute (arg)
				value := not operand1.value
				if not value then
					operand2.execute (arg)
					value := operand2.value
				end
			else
				set_value_to_default
			end
		ensure then
			implication_value: value = (operand1.value implies operand2.value)
		rescue
			exception_occurred := True
			retry
		end

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN) is
			-- (Not used.)
		do
		end

end
