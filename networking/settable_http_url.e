note
	description: "HTTP_URLs with settable attributes"
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
    copyright: "Copyright (c) 1998-2014, Jim Cochrane"
    license:   "GPL version 2 - http://www.gnu.org/licenses/gpl-2.0.html"

class

	SETTABLE_HTTP_URL

inherit

	HTTP_URL
		export
			{ANY} address
		end

create

	http_make

feature -- Initialization

	http_make (h, p: STRING)
		require
			args_valid: h /= Void and p /= Void
		do
			host := h
			path := p
			make ("http://" + host + "/" + path)
		ensure
			host_set: host /= Void and host = h
			path_set: path /= Void and path = p
			address_set: address.is_equal ("http://" + host + "/" + path)
		end

feature -- Element change

	set_host (h: STRING)
		require
			h_valid: h /= Void and not h.is_empty
		do
			host := h
			make_address
		ensure
			host_set: host /= Void and host = h
			address_set: address.is_equal ("http://" + host + "/" + path)
		end

	set_path (p: STRING)
		require
			p_valid: p /= Void and not p.is_empty
		do
			path := p
			make_address
		ensure
			path_set: path /= Void and path = p
			address_set: address.is_equal ("http://" + host + "/" + path)
		end

feature {NONE} -- Implementation

	make_address
		do
			address := "http://" + host + "/" + path
		end

end
