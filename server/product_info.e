note
	description: "Information about the current version of an application"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class PRODUCT_INFO inherit

	GENERAL_UTILITIES
		export
			{NONE} all
			{ANY} deep_twin, is_deep_equal, standard_is_equal
		end

feature -- Access

	name: STRING
		deferred
		end

	number: STRING
			-- The version number as a string
		local
			i: INTEGER
		once
			create Result.make(0)
			from
				i := 1
			until
				i = number_components.count
			loop
				Result.append (number_components @ i)
				Result.append (".")
				i := i + 1
			end
			Result.append (number_components @ i)
		end

	number_components: ARRAY [STRING]
			-- The components of the version number
			-- Components are strings to allow mixed numbers and letters.
		deferred
		end

	date: DATE
			-- The last date that `number' was updated
		deferred
		end

	informal_date: STRING
			-- Date in the format 'month, dd, yyyy', where month is a
			-- month name in English - January, February, ...
		once
			Result := concatenation (<<months @ date.month, " ",
						date.day, ", ", date.year>>)
		end

	copyright: STRING
			-- The copyright, if any, for the application
		deferred
		end

	license_information: STRING
			-- The license, if any, for the application
		deferred
		end

	assertion_report: STRING
			-- Report: Are assertions on or off?
		local
			assertions_on: BOOLEAN
		do
			if not assertions_on then
				Result := "Assertion checking is disabled."
				-- Trick to determine if assertions are on:
				violate_precondition
			else
				Result := "Assertion checking is enabled."
			end
		rescue
			assertions_on := True
			retry
		end

feature {NONE} -- Implementation

	months: TABLE [STRING, INTEGER]
		local
			r: ARRAY [STRING]
		once
			r := <<"January", "February", "March", "April",
					"May", "June", "July", "August",
					"September", "October", "November", "December">>
			Result := r
		end

	violate_precondition
			-- Tool for checking if assertions are on
		require
			impossible: False
		do
		end

end -- class PRODUCT_INFO
