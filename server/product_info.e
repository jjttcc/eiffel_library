indexing
	description: "Information about the current version of an application"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class PRODUCT_INFO inherit

	GENERAL_UTILITIES
		export
			{NONE} all
		end

feature -- Access

	name: STRING is
		deferred
		end

	number: STRING is
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

	number_components: ARRAY [STRING] is
			-- The components of the version number
			-- Components are strings to allow mixed numbers and letters.
		deferred
		end

	date: DATE is
			-- The last date that `number' was updated
		deferred
		end

	informal_date: STRING is
			-- Date in the format 'month, dd, yyyy', where month is a
			-- month name in English - January, February, ...
		once
			Result := concatenation (<<months @ date.month, " ",
						date.day, ", ", date.year>>)
		end

	copyright: STRING is
			-- The copyright, if any, for the application
		deferred
		end

	license_information: STRING is
			-- The license, if any, for the application
		deferred
		end

feature {NONE} -- Implementation

	months: TABLE [STRING, INTEGER] is
		local
			r: ARRAY [STRING]
		once
			r := <<"January", "February", "March", "April",
					"May", "June", "July", "August",
					"September", "October", "November", "December">>
			Result := r
		end

end -- class PRODUCT_INFO
