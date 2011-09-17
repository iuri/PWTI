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

# new-portal/www/layouts/simple2.tcl

ad_page_contract {
    This is a simple 2 column layout called from portal::render and the like. 
    It laysout the elements with portal::layout_elements and hands off rendering
    of the individual portlets to the template in the "element_src" var

    @version $Id: zen2.tcl,v 1.1.2.2 2007/02/21 01:45:22 donb Exp $
} -properties {
    element_list:onevalue
    element_src:onevalue
    action_string:onevalue
    theme_id:onevalue
    return_url:onevalue
}

if {![exists_and_not_null action_string]} {
    set action_string ""
}

if {![exists_and_not_null theme_id]} {
    set theme_id ""
}

if {![exists_and_not_null return_url]} {
    set return_url [ad_return_url]
}

portal::layout_elements $element_list

set element_2_first_num [llength $element_ids_1] 


