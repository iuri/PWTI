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

    Procedures to support the xowiki ADMIN portlet

    @author arjun@openforce.net
    @cvs-id $Id: xowiki-admin-portlet-procs.tcl,v 1.1 2007/01/31 10:52:48 gustafn Exp $
}

namespace eval xowiki_admin_portlet {

    ad_proc -private get_my_name {
    } {
	return "xowiki_admin_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return [parameter::get_from_package_key \
		    -package_key [my_package_key] \
		    -parameter xowiki_admin_portlet_pretty_name]
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
	Adds a xowiki admin PE to the given portal
    } {
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -key package_id \
            -value $package_id
        ]
	ns_log notice "end of add_self_to_page"
    }

    ad_proc -public remove_self_from_page {
	{-portal_id:required}
    } {
	Removes xowiki PE from the given page
    } {
        # This is easy since there's one and only one instace_id
        portal::remove_element \
            -portal_id $portal_id \
            -portlet_name [get_my_name]
    }

    ad_proc -public show {
	cf
    } {
	Display the PE
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "xowiki-admin-portlet"
    }

}
