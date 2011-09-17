#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_library {

    Procedures to supports xowiki portlets.
}

namespace eval xowiki_portlet {

    ad_proc -private get_my_name {
    } {
	return "xowiki_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
	return ""
    }

    ad_proc -private my_package_key {
    } {
        return "xowiki-portlet"
    }

    ad_proc -public link {
    } {
	return ""
    }

    ad_proc -public add_self_to_page {
	{-portal_id:required}
	{-package_id:required}
    } {
	Adds a static PE to the given page
    } {
        ns_log notice "xowiki_portlet::add_self_to_page - Don't call me. Use static_portal_content:: instead"
        error
    }

    ad_proc -public remove_self_from_page {
	portal_id
	element_id
    } {
	Removes static PE from the given page
    } {
        # This is easy since there's one and only one instace_id
        portal::remove_element $element_id
    }

    ad_proc -public show {
	cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "xowiki-portlet"
    }
}
