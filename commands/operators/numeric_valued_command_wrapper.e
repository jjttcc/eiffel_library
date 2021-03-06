note
	description: "Commands (which conform to RESULT_COMMAND [DOUBLE])%
		%with a DOUBLE `value' that serve to wrap an `item' of type COMMAND %
		%(that is, a possibly non-numeric command).  After executing %
		%`item', feature `value' is assigned as follows: If `item.value' %
		%is DOUBLE, `value' is set to its value; if `item.value' is BOOLEAN %
		%and is True, `value' is set to 1; if `item.value' is BOOLEAN and %
		%False, value is set to 0.  If `item' is a COMMAND_SEQUENCE whose %
		%`main_operator' is not Void, the preceding steps are followed %
		%recursively on its main_operator.  Otherwise, `item' is assumed to %
		%not have a value and `value' is set to 0."
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class NUMERIC_VALUED_COMMAND_WRAPPER inherit

	RESULT_COMMAND [DOUBLE]
		redefine
			initialize, children
		end

creation

	make

feature {NONE} -- Initialization

	make (o: like item)
		require
			not_void: o /= Void
		do
			set_item (o)
		ensure
			set: item = o
		end

feature -- Initialization

	initialize (arg: ANY)
		do
			item.initialize (arg)
		end

feature -- Access

	item: COMMAND

	children: LIST [COMMAND]
		do
			create {LINKED_LIST [COMMAND]} Result.make
			Result.extend (item)
		end

feature -- Status report

	arg_mandatory: BOOLEAN
		do
			Result := item.arg_mandatory
		end

feature -- Element change

	set_item (arg: like item)
			-- Set item to `arg'.
		require
			arg /= Void
		do
			item := arg
		ensure
			item_set: item = arg and item /= Void
		end

feature -- Basic operations

	execute (arg: ANY)
		do
			item.execute (arg)
			attemp_to_extract_result (item)
		end

feature {NONE} -- Implementation

	attemp_to_extract_result (cmd: COMMAND)
			-- Attempt, after `cmd' has been executed, to extract its
			-- result into `value'.
		local
			real_cmd: RESULT_COMMAND [DOUBLE]
			bool_cmd: RESULT_COMMAND [BOOLEAN]
			cmd_seq: COMMAND_SEQUENCE
		do
			real_cmd ?= cmd
			if real_cmd /= Void then
				value := real_cmd.value
			else
				bool_cmd ?= cmd
				if bool_cmd /= Void then
					if bool_cmd.value then
						value := 1
					else
						value := 0
					end
				else
					cmd_seq ?= cmd
					if cmd_seq /= Void and cmd_seq.main_operator /= Void then
						attemp_to_extract_result (cmd_seq.main_operator)
					else
						value := 0
					end
				end
			end
		end

invariant

	item_exists: item /= Void

end
