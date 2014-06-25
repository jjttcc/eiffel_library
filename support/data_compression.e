note
	description: "Common features for data compression and decompression";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

deferred class DATA_COMPRESSION inherit

feature -- Access

	product_count: INTEGER
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

	execute
			-- Unlock the file.
		do
			error_occurred := False
			process_target
			if not error_occurred then
				processed := True
			end
		ensure then
			processed: processed or error_occurred
		end

feature {NONE} -- Implementation

	process_target
		require
			no_error: error_occurred = False
		deferred
		end

invariant

	processed = (product_count > 0)

end -- class DATA_COMPRESSION
