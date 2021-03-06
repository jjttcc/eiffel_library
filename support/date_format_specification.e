note
	description: "Specification of date-format settings"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class DATE_FORMAT_SPECIFICATION inherit

	ERROR_PUBLISHER
		export
			{ERROR_SUBSCRIBER} all
			{ANY} deep_twin, is_deep_equal, standard_is_equal
		end

creation

	make

feature {NONE} -- Initialization

	make (date_prefix: STRING)
		do
			year_partition_value := Default_year_partition_value
			date_format_prefix := date_prefix
		ensure
			default_partition:
				year_partition_value = Default_year_partition_value
			prefix_set: date_format_prefix = date_prefix
		end

feature -- Access

	date_format_prefix: STRING
			-- Prefix of the "date format" option

	day_index: INTEGER
			-- Index of the day portion of the date

	month_index: INTEGER
			-- Index of the month portion of the date

	year_index: INTEGER
			-- Index of the year portion of the date

	three_letter_month_abbreviation: BOOLEAN
			-- Is a 3-letter month format ("Jan", etc.) being used?

	convert_2_digit_year: BOOLEAN
			-- Are 2-digit years (which need to be converted to 4-digit
			-- years) used in the date?

	year_partition_value: INTEGER
			-- When `convert_2_digit_year', value for which the year component,
			-- yy, of the date will be formatted according to the rule:
			--    yy > `year_partition_value': year -> yy + 1900
			--    yy <= `year_partition_value': year -> yy + 2000

	date_field_separator: STRING
			-- Field separator for dates - e.g., for 01/22/2000: "/"

feature -- Access - constants

	Default_year_partition_value: INTEGER = 25
			-- Default value for `year_partition_value' if none is
			-- otherwise specified

feature -- Basic operations

	process_option (arg: STRING)
			-- Process `arg' as a "special-formatting" option.
		local
			optstring: STRING
			components: LIST [STRING]
		do
			valid := True
			convert_2_digit_year := False
			optstring := arg.substring (date_format_prefix.count + 1,
				arg.count)
			components := optstring.split (main_field_sep)
			components.do_all (agent process_sub_component)
		end

feature -- Status report

	valid: BOOLEAN
			-- Are the current settings valid?

feature {NONE} -- Implementation

	process_sub_component (s: STRING)
			-- Process `s' as a sub-component of a "special-formatting"
			-- option (e.g., option=value).
		local
			setting: LIST [STRING]
		do
			setting := s.split (subfield_sep)
			if
				setting.count < 2 or
				not format_setters.has (setting @ 1)
			then
				publish_error (Invalid_date_specification_component_error +
					" (" + setting @ 1 + ")")
				valid := False
			else
				format_setters.item (setting @ 1).call ([setting @ 2])
			end
		end

	set_date_format (setting: STRING)
		local
			values: LIST [STRING]
		do
			values := setting.split (date_format_field_separator)
			if
				values.count /= 3
			then
				publish_error (Invalid_date_format_error + " (" +
					setting + ")")
				valid := False
			else
				from
					values.start
				until
					values.exhausted
				loop
					if values.item.is_equal (day_specifier) then
						day_index := values.index
					elseif
						values.item.is_equal (
							month_abbreviation_specifier)
					then
						month_index := values.index
						three_letter_month_abbreviation := True
					elseif values.item.is_equal (month_specifier) then
						month_index := values.index
					elseif values.item.is_equal (year_specifier4) then
						year_index := values.index
					elseif values.item.is_equal (year_specifier2) then
						year_index := values.index
						convert_2_digit_year := True
					end
					values.forth
				end
			end
		end

	set_date_separator (setting: STRING)
		do
			if setting.is_integer then
				publish_error (Numeric_date_separator_error)
				valid := False
			else
				date_field_separator := setting.twin
			end
		end

	set_year_partition (setting: STRING)
		local
			v: INTEGER
		do
			if setting.is_integer then
				v := setting.to_integer
				if v > 0 and v < 100 then
					year_partition_value := v
				else
					publish_error (Invalid_year_partition_value_error +
						" (" + setting + ")")
					valid := False
				end
			else
				publish_error (Non_numeric_year_partition_error +
					" (" + setting + ")")
				valid := False
			end
		end

feature {NONE} -- Implementation constants

	main_field_sep: CHARACTER = ','
			-- Field separator for the "date format" components

	subfield_sep: CHARACTER = '='
			-- Internal field separator for a "date format" component
			-- (e.g., "option=value")

	format_setters: HASH_TABLE [PROCEDURE [ANY, TUPLE [STRING]],
		STRING]
			-- Agents for setting date format options
		once
			create Result.make (0)
			Result.put (agent set_date_format, "date-format")
			Result.put (agent set_date_separator, "date-sep")
			Result.put (agent set_year_partition, "year-partition")
		end

	month_abbreviation_specifier: STRING = "month3"
			-- Command-line specifier for abbreviated ("Jan", ...) date format

	day_specifier: STRING = "dd"
			-- Command-line specifier for day part of the date format

	month_specifier: STRING = "mm"
			-- Command-line specifier for (conventional) month part of the
			-- date format

	year_specifier4: STRING = "yyyy"
			-- Command-line specifier for year part of the date format for
			-- 4-digit years

	year_specifier2: STRING = "yy"
			-- Command-line specifier for year part of the date format for
			-- 2-digit years

	date_format_field_separator: CHARACTER = '#'
			-- Field separator for command-line provided date-format
			-- specification

feature {NONE} -- Error constants

	Invalid_year_partition_value_error: STRING =
		"Year partition value is invalid - must be > 0 and < 100."

	Non_numeric_year_partition_error: STRING =
		"Year partition value not a number."

	Invalid_date_specification_component_error: STRING =
		"Date specification component is invalid."

	Invalid_date_format_error: STRING = "Date format is invalid."

	Numeric_date_separator_error: STRING = "Date separator is numeric."

invariant

	year_partition_valid: convert_2_digit_year implies year_partition_value > 0

end
