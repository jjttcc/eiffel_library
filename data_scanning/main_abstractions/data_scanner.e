indexing
	description: "";
	date: "$Date$";
	revision: "$Revision$"

class 
	DATA_SCANNER

feature -- Access

	tuples: ARRAY [MARKET_TUPLE]
			-- Tuples produced by scanning the input

feature -- Basic operations

	execute is
			-- Scan input and create tuples from it
		local
			i: INTEGER
			tuple: MARKET_TUPLE
		do
			from
				-- open input_file (with what filename?)
				input_file.start
			invariant
			until
				input_file.after
			loop
				tuple_maker.execute (Void)
				tuple := tuple_maker.product
				from
					value_setters.start
					check not value_setters.after end
					value_setters.item.set (input_file, tuple)
					value_setters.forth
				invariant
				until
					value_setters.after
				loop
					from -- Eat field separator
						i := 1
						-- !!!This part (the inner loop) needs to be
						-- !!!abstracted and made more flexible.
					until
						i > field_separator.count
					loop
						input_file.read_character
						check
							input_file.last_character = field_separator @ i
						end
						i := i + 1
					end
					value_setters.item.set (input_file, tuple)
					value_setters.forth
				end
				from -- Eat record separator
					i := 1
					-- !!!This part (the inner loop) needs to be
					-- !!!abstracted and made more flexible.
				until
					i > record_separator.count
				loop
					input_file.read_character
					check
						input_file.last_character = record_separator @ i
					end
					i := i + 1
				end
				-- input_file.forth or whatever - increment to next record
			end
		end

feature {NONE}

	tuple_maker: TUPLE_FACTORY
			-- Tuple manufacturer

	value_setters: LINEAR [VALUE_SETTER]
			-- Used to scan input and set the appropriate tuple fields

	field_separator: STRING
			-- Character(s) that separate each field in the input

	record_separator: STRING
			-- Character(s) that separate each record in the input

	input_file: FILE
			-- Input file or stream

end -- class DATA_SCANNER
