indexing
	description: "data decompression of STRINGs using zlib library";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2004: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class ZLIB_DECOMPRESSION inherit

	DATA_COMPRESSION
		rename
			process_target as decompress_target
		end

	ZLIB

creation

	make

feature -- Initialization

	make (tgt: like target; tgt_count, max_prod_count: INTEGER) is
			-- tgt_count is the size in bytes of tgt;
			-- max_prod_count is the maximum possible size in bytes of the
			-- decompressed product.
		require
			not_void: tgt /= Void
			count_gt_0: tgt_count > 0 and max_prod_count > 0
		do
			product_count := 0
			target := tgt
			max_product_count := max_prod_count
			target_count := tgt_count
			if product = Void then create product.make (0) end
		ensure
			set: target = tgt and max_product_count = max_prod_count and
				target_count = tgt_count
		end

feature -- Access

	target: SPECIAL [CHARACTER]

	product: STRING

	raw_product: POINTER

	product_count: INTEGER

	target_count: INTEGER
			-- The size in bytes of `target'

	max_product_count: INTEGER
			-- The maximum possible size in bytes of the decompressed product

feature {NONE} -- Implementation

	decompress_target is
		local
			buffer: TO_SPECIAL [CHARACTER]
			cmpresult: INTEGER
			dest, src: ANY
		do
			create buffer.make_area (max_product_count)
			product_count := max_product_count
			dest := buffer.area
			src := target
			cmpresult := zlib_uncompress ($dest, $product_count,
				$src, target_count)
			if
				cmpresult /= No_error and not
				(cmpresult = Buffer_error and product_count > 0)
				-- For some reason, zlib uncompress gives a buffer
				-- error even when it succeeds - assume then that there
				-- is a problem only if product_count is 0.
			then
				error_occurred := True
				product_count := 0
				last_error := error_value (cmpresult)
			else
				product.from_c_substring ($dest, 1, product_count)
			end
		end

feature {NONE} -- Implementation - external routines

	zlib_uncompress (destination: POINTER; destsize: POINTER; source: POINTER;
			sourcesize: INTEGER): INTEGER is
		external
			"C"
		end

end -- class ZLIB_DECOMPRESSION
