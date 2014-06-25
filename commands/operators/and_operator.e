note
	description: "Boolean 'and' operator"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class AND_OPERATOR inherit

	BINARY_OPERATOR [BOOLEAN, BOOLEAN]
		redefine
			execute -- Take advantage of "and" optimization.
		end

creation

	make

feature -- Basic operations

	execute (arg: ANY)
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
				value := operand1.value
				if value then
					operand2.execute (arg)
					value := operand2.value
				end
			else
				set_value_to_default
			end
		ensure then
			and_value: value = (operand1.value and then operand2.value)
		rescue
			exception_occurred := True
			retry
		end

feature {NONE} -- Hook routine implementation

	operate (v1, v2: BOOLEAN)
			-- (Not used.)
		do
		end

end -- class AND_OPERATOR
