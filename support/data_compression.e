indexing
	description: "Common features for data compression and decompression";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

deferred class DATA_COMPRESSION inherit

feature -- Access

	product_count: INTEGER is
			-- Size of the processed product
		deferred
		end

feature -- Access

	last_error: STRING
			-- Description of last error

feature -- Status report

	processed: BOOLEAN
			-- Has the data compression target been processed?

	error_occurred: BOOLEAN
			-- Did an error occur while processing?

feature -- Basic operations

	execute is
			-- Unlock the file.
		do
			error_occurred := false
			process_target
			if not error_occurred then
				processed := true
			end
		ensure then
			processed: processed or error_occurred
		end

feature {NONE} -- Implementation

	process_target is
		require
			no_error: error_occurred = false
		deferred
		end

invariant

	processed = (product_count > 0)

end -- class DATA_COMPRESSION
