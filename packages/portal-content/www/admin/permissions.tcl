ad_page_contract {
    Permissions for the subsite itself.
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-13
    @cvs-id $Id: permissions.tcl,v 1.2 2004/03/29 15:07:35 peterm Exp $
}

set object_id [ad_conn package_id]

set page_title [_ portal-content.Permissions]

set context [list $page_title]

