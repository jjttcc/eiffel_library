indexing
	description: "data compression of STRINGs using zlib library";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"

class ZLIB_COMPRESSION inherit

	DATA_COMPRESSION
		rename
			process_target as compress_target
		end

	ZLIB

creation

	make

feature -- Initialization

	make (tgt: like target) is
			-- Initialize with `tgt' as target.
		do
			target := tgt
			product_count := 0
		ensure
			target_set: target = tgt
		end

feature -- Access

	target: STRING

	product: STRING is
		local
			raw: ANY
		do
			if product_implementation = Void then
				create product_implementation.make (0)
				raw := raw_product.area
				product_implementation.from_c_substring ($raw, 1, product_count)
			end
			Result := product_implementation
		end

	raw_product: TO_SPECIAL [CHARACTER]

	product_count: INTEGER

feature {NONE} -- Implementation

	compress_target is
		local
			buffcount: INTEGER
			src, dest: ANY
			cmpresult: INTEGER
		do
			product_implementation := Void
			buffcount := (target.count + target.count * .0015 + 25).ceiling
			create raw_product.make_area (buffcount)
			src := target.area
			dest := raw_product.area
			cmpresult := zlib_compress2 ($dest, $buffcount, $src,
				target.area.count, compression_level)
			check
				compression_level_was_valid: cmpresult /= Stream_error
			end
			if cmpresult /= No_error then
				error_occurred := true
				product_count := 0
				last_error := error_value (cmpresult)
			else
				product_count := buffcount
			end
		end

	product_implementation: STRING

	compression_level: INTEGER is 9
			-- zlib compression level

feature {NONE} -- Implementation - external routines

	zlib_compress2 (destination: POINTER; destcount: POINTER;
			source: POINTER; sourcecount, level: INTEGER): INTEGER is
		external
			"C"
		end

	zlib_compress (destination: POINTER; destcount: POINTER;
			source: POINTER; sourcecount: CHARACTER): INTEGER is
		external
			"C"
		end

invariant

	compression_level >= 0 and compression_level <= 9

end -- class ZLIB_COMPRESSION
