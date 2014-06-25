note
	description: "Common facilities for zlib compression/decompression";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class ZLIB

feature -- Error status values

	No_error: INTEGER = 0
			-- No error occurred

	Memory_error: INTEGER = -4
			-- Out of memory

	Buffer_error: INTEGER = -5
			-- Output buffer was too small

	Stream_error: INTEGER = -2
			-- Compression level was invalid

	Data_error: INTEGER = -3
			-- Input data for decompression was corrupted

feature {NONE} -- Implementation

	error_value (error_status: INTEGER): STRING
			-- Description of `error_status' value
		do
			inspect
				error_status
			when No_error then
				Result := ""
			when Memory_error then
				Result := "Ran out of memory during compression/decompression."
			when Buffer_error then
				Result := "Output buffer was too small for %
					%compression/decompression."
			when Stream_error then
				Result := "Invalid compression level specified."
			when Data_error then
				Result := "Input data for decompression was corrupted."
			else
				Result := ""
			end
		end

end -- class ZLIB
