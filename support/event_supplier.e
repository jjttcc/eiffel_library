indexing
	description: "Suppliers for EVENT_CLIENTs"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 2003: Jim Cochrane - %
		%License to be determined"

deferred class EVENT_SUPPLIER

feature -- Basic operations

	register_client (p: PROCEDURE [ANY, TUPLE [EVENT_SUPPLIER]]) is
			-- Register `p' as a client action to be called when
			-- an event has occurred.
		require
			arg_exists: p /= Void
		do
			if client_actions = Void then
				create client_actions.make
			end
			client_actions.extend (p)
		ensure
			client_actions_exist: client_actions /= Void
			p_added: client_actions.has (p)
		end

feature {NONE} -- Implementation

	client_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [EVENT_SUPPLIER]]]

	notify_clients is
			-- Call all agents in `client_actions' with Current as an argument.
		do
			if client_actions /= Void then
				from
					client_actions.start
				until
					client_actions.exhausted
				loop
					client_actions.item.call ([Current])
					client_actions.forth
				end
			end
		end

end
