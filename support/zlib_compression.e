note
	description: "data compression of STRINGs using zlib library";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class ZLIB_COMPRESSION inherit

	DATA_COMPRESSION
		rename
			process_target as compress_target
		end

	ZLIB

creation

	make

feature -- Initialization

	make (tgt: like target)
			-- Initialize with `tgt' as target.
		do
			target := tgt
			product_count := 0
		ensure
			target_set: target = tgt
		end

feature -- Access

	target: STRING

	product: STRING
		local
			raw: ANY
		do
			if product_implementation = Void then
				create product_implementation.make (0)
				raw := raw_product
				product_implementation.from_c_substring ($raw_product, 1,
					product_count)
			end
			Result := product_implementation
		end

	raw_product: SPECIAL [CHARACTER]

	product_count: INTEGER

feature {NONE} -- Implementation

	compress_target
		local
			buffcount: INTEGER
			src, dest: ANY
			cmpresult: INTEGER
			timer: TIMER
			buffer: TO_SPECIAL [CHARACTER]
		do
			debug ("compression")
				create timer.make
			end
			product_implementation := Void
			buffcount := (target.count + target.count * .0015 + 25).ceiling
			create buffer.make_empty_area (buffcount)
			src := target.area
			raw_product := buffer.area
			dest := raw_product
			cmpresult := zlib_compress2 ($dest, $buffcount, $src,
				target.area.count, compression_level)
			check
				compression_level_was_valid: cmpresult /= Stream_error
			end
			if cmpresult /= No_error then
				if cmpresult = Buffer_error then
					-- Buffer was too small - Try again with a larger buffer.
					buffcount := buffcount + 254
					create buffer.make_empty_area (buffcount)
					raw_product := buffer.area
					dest := raw_product
					cmpresult := zlib_compress2 ($dest, $buffcount, $src,
						target.area.count, compression_level)
					if cmpresult /= No_error then
						error_occurred := True
						product_count := 0
						last_error := error_value (cmpresult)
					else
						product_count := buffcount
					end
				else
					error_occurred := True
					product_count := 0
					last_error := error_value (cmpresult)
				end
			else
				product_count := buffcount
			end
			debug ("compression")
				print ("Compression took ");
				print (timer.elapsed_time.fine_seconds_count); print ("%N")
				print ("target size: ");
				print (target.count)
				print (", product size: ");
				print (product_count)
				print ("%N");
			end
		end

	product_implementation: STRING

	compression_level: INTEGER = 9
			-- zlib compression level

feature {NONE} -- Implementation - external routines

	zlib_compress2 (destination: POINTER; destcount: POINTER;
			source: POINTER; sourcecount, level: INTEGER): INTEGER
		external
			"C"
		end

	zlib_compress (destination: POINTER; destcount: POINTER;
			source: POINTER; sourcecount: CHARACTER): INTEGER
		external
			"C"
		end

invariant

	compression_level >= -1 and compression_level <= 9

end -- class ZLIB_COMPRESSION
