ad_page_contract {
    Unmapping a patch from a content.

    @author Peter Marklund (peter@collaboraid.biz)
    @date 2002-09-06
    @cvs-id $Id: unmap-patch-from-content.tcl,v 1.3 2004/03/29 15:07:34 peterm Exp $
} {
    patch_number:integer,notnull
    content_number:integer,notnull
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set write_p [ad_permission_p $package_id write]
set user_is_submitter_p [expr $user_id == [portal_content::get_patch_submitter -patch_number $patch_number]]

if { ![expr $user_is_submitter_p || $write_p] } {            
    ad_return_forbidden "[_ portal-content.Permission]" "[_ portal-content.You_7]"            
    ad_script_abort
}

portal_content::unmap_patch_from_content -patch_number $patch_number -content_number $content_number

ad_returnredirect "patch?patch_number=$patch_number"
