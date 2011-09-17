ad_page_contract {
    Bug listing page.
    
    @author Lars Pind (lars@pinds.com)
    @creation-date 2002-03-20
    @cvs-id $Id: index.tcl,v 1.19 2005/02/24 13:33:04 jeffd Exp $
} [portal_content::get_page_variables]

set page_title [ad_conn instance_name]
set context [list]
set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]
portal_content::get_pretty_names -array pretty_names

if { [llength [portal_content::components_get_options]] == 0 } {
    ad_return_template "no-components"
    return
}

if { ![portal_content::contents_exist_p] } {
    ad_return_template "no-contents"
    return
}

set project_id [ad_conn package_id]

#####
#
# Get content list
#
#####


# TODO: Get /com/* URLs working again
# TODO: Other important suggestions from threads, etc.
# TODO: Bulk actions (set fix for version, reassign, etc.)


portal_content::content::get_list

portal_content::content::get_multirow


