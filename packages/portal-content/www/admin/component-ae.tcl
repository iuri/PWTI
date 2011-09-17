ad_page_contract {
    @author Lars Pind (lars@pinds.com)
    @creation-date 2002-03-26
    @cvs-id $Id: component-ae.tcl,v 1.10 2004/03/29 15:07:35 peterm Exp $
} {
    component_id:integer,optional
    {return_url "."}
}

set package_id [ad_conn package_id]
set Component_name [portal_content::conn Component]
set component_name [portal_content::conn component]

if { [info exists component_id] } {
    set page_title [_ portal-content.Edit_1]
} else {
    set page_title [_ portal-content.Add]
}
set context [list $page_title]

# LARS:
# I've hidden the description, because we don't use it anywhere
set filter_url_string "[ad_conn package_url]com/this-name/"

ad_form -name component -cancel_url $return_url -form {
    {component_id:key(acs_object_id_seq)}
    {return_url:text(hidden) {value $return_url}}
    {name:text {html { size 50 }} {label "[_ portal-content.Component]"}}
    {description:text(hidden),optional {label {Description}} {html { cols 50 rows 8 }}}
    {url_name:text,optional {html { size 50 }} {label {[_ portal-content.Name_in_shortcut_URL]}}
        {help_text "[_ portal-content.You]"}
    }
    {maintainer:search,optional
        {result_datatype integer}
        {label "[_ portal-content.Maintainer]"}
        {options [portal_content::users_get_options]}
        {search_query {[db_map user_search]}}
    }
} -select_query {
    select component_id, 
           component_name as name, 
           description, 
           maintainer,
           url_name
    from   bt_components
    where  component_id = :component_id
} -new_data {
    db_dml component_create {}
} -edit_data {
    db_dml component_update {}
} -after_submit {
    portal_content::components_flush

    ad_returnredirect $return_url
    ad_script_abort
}
