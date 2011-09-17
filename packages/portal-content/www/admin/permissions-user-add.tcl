ad_page_contract {
    Redirect page for adding users to the permissions list.
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-13
    @cvs-id $Id: permissions-user-add.tcl,v 1.2 2004/03/29 15:07:35 peterm Exp $
}

set object_id [ad_conn package_id]

set page_title [_ portal-content.Add_1]

set context [list [list "permissions" "[_ portal-content.Permissions]"] $page_title]

