indexing
	description: "Test class for compression"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2003: Jim Cochrane - %
		%Released under the Eiffel Forum License; see file forum.txt"

class COMPRESSION_TEST inherit

	GENERAL_UTILITIES
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make is do end

feature -- Basic operations

	execute (n: INTEGER) is
			-- Execute the compression test `n' times.
		local
			i: INTEGER
		do
			from i := 0 until i = n loop
				i := i + 1
				print_list (<<"zlib test #", i, "%N">>)
				zlib_testrun
			end
		end

feature {NONE} -- Implementation

	report_zlib_error (item: DATA_COMPRESSION) is
		do
			if item.error_occurred then
				print_list (<<"Error occurred in compression: ",
					item.last_error, "%N">>)
			end
		end

	zlib_testrun is
		local
			c: ZLIB_COMPRESSION
			d: ZLIB_DECOMPRESSION
			s: STRING
			timer: TIMER
		do
			create c.make (largestring)
			create timer.make
			c.execute
			report_zlib_error (c)
			print_list (<<"time, in seconds, it took to compress the data: ",
						timer.elapsed_time.fine_seconds_count, "%N">>);
			print_list (<<"Original string size: ", c.target.count,
				", compressed string size: ", c.product_count, "%N">>)
			s := c.product
		--	print_list (<<"Original string: <<<", c.target,
		--		">>>%N, compressed string: <<<", s, ">>>%N">>)
			create d.make (c.raw_product, c.product_count, c.target.count)
			timer.start
			d.execute
			report_zlib_error (d)
			print_list (<<"time, in seconds, it took to uncompress the data: ",
						timer.elapsed_time.fine_seconds_count, "%N">>);
			print_list (<<"Original string size: ", c.target.count,
				", decompressed string size: ", d.product_count, "%N">>)
		--	print_list (<<"decompressed string: ", d.product, "%N">>)
		--	c.target.put ('X', 523)
			print_list (<<"original is equal to decompressed area: ",
				a_eq_b (c.target.area, d.product.area, d.product_count).out,
				"%N">>)
			print_list (<<"original is equal to decompressed string: ",
				c.target.is_equal (d.product).out, "%N">>)
		end

	largestring: STRING is
		local
			i: INTEGER
			zero: CHARACTER
		do
			Result := "beginning of the string"
			zero := '0'
			from
				i := 0
			until
				i = 2500
			loop
				Result.extend (zero + (i \\ (255 - (zero.code)) + 1))
				if i \\ 78 = 0 then
					Result.extend ('%N')
				end
				i := i + 1
			end
			from
				i := 0
			until
				i = 2500
			loop
				Result.extend ('z')
				if i \\ 78 = 0 then
					Result.extend ('%N')
				end
				i := i + 1
			end
			from
				i := 0
			until
				i = 2500
			loop
				Result.extend (zero + (i \\ (255 - zero.code) + 1))
				if i \\ 78 = 0 then
					Result.extend ('%N')
				end
				i := i + 1
			end
			from
				i := 0
			until
				i = 2500
			loop
				Result.extend ('A')
				if i \\ 78 = 0 then
					Result.extend ('%N')
				end
				i := i + 1
			end
		end

	a_eq_b (a, b: SPECIAL [CHARACTER]; size: INTEGER): BOOLEAN is
		local
			i: INTEGER
		do
			from
				i := 0
				Result := True
			until
				not Result or i = size
			loop
				if a.item (i) /= b.item (i) then
					Result := False
					print_list (<<"a_eq_b found false result at ", i,
						"(", a.item (i), ", ", b.item (i), ")%N">>)
				end
				if a.item (i) = '%U' then
					print_list (<<"a_eq_b Encountered a null character at ",
						i, "%N">>)
				end
				i := i + 1
			end
		end

end -- class COMPRESSION_TEST
