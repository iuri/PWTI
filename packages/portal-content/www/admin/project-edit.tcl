ad_page_contract {
    Pick a project maintainer

    @author Lars Pind (lars@pinds.com)
    @creation-date 2002-03-26
    @cvs-id $Id: project-edit.tcl,v 1.9 2004/03/29 15:07:35 peterm Exp $
} {
    {return_url "."}
}

set project_name [portal_content::conn project_name]
set package_id [ad_conn package_id]

set page_title [_ portal-content.Edit_2]
set context [list $page_title]

ad_form -name project -cancel_url $return_url -form {
    package_id:key
    {return_url:text(hidden) {value $return_url}}
    {name:text {html { size 50 }} {label "[_ portal-content.Project]"}
        {help_text {This is also the name of this package in the site map}}
    }
    {description:text(hidden),optional {label "[_ portal-content.Description]"} {html { cols 50 rows 8 }}
        {help_text {This isn't actually used anywhere at this point. Sorry.}}
    }
    {email_subject_name:text,optional {html { size 50 }} {label "[_ portal-content.Notification]"}
        {help_text {This text will be included in square brackets at the beginning of all notifications, for example \[OpenACS Bugs\]}}
    }
    {maintainer:search,optional
        {result_datatype integer}
        {label {Project Maintainer}}
        {options [portal_content::users_get_options]}
        {search_query {[db_map dbqd.acs-tcl.tcl.community-core-procs.user_search]}}
    }
} -select_query_name project_select -edit_data {
    db_transaction {
        db_dml project_info_update {}

        portal_content::set_project_name $name
    }
    site_nodes_sync
    portal_content::get_project_info_flush
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}

