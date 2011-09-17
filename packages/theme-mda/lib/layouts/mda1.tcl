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

ad_page_contract {

    @cvs_id $Id: zen1.tcl,v 1.1.2.1 2007/01/29 02:51:36 donb Exp $

} -properties {
    element_list:onevalue
    element_src:onevalue
    action_string:onevalue
    theme_id:onevalue
    return_url:onevalue
}

if { ![info exists action_string]} {
    set action_string ""
}

if { ![info exists theme_id]} {
    set theme_id ""
}

if { ![info exists return_url]} {
    set return_url [ad_return_url]
}

portal::layout_elements $element_list



ad_return_template



