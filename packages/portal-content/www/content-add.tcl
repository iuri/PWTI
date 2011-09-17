ad_page_contract {
    Bug add page.
    
    @author Lars Pind (lars@pinds.com)
    @creation-date 2002-03-25
    @cvs-id $Id: content-add.tcl,v 1.14 2005/03/01 00:01:26 jeffd Exp $
} {
    {return_url ""}
}

if { [empty_string_p $return_url] } {
    set return_url "."
}

ad_require_permission [ad_conn package_id] create

# User needs to be logged in here
auth::require_login

# Set some common portal-content variables
set project_name [portal_content::conn project_name]
set package_id [ad_conn package_id]
set package_key [ad_conn package_key]

set Bug_name [portal_content::conn Bug]
set page_title [_ portal-content.New_1]

set workflow_id [portal_content::content::get_instance_workflow_id]

set context [list $page_title]

set user_id [ad_conn user_id]

# Is this project using multiple versions?
set versions_p [portal_content::versions_p]

# Create the form
ad_form -name content -cancel_url $return_url -form {
    content_id:key(acs_object_id_seq) 

    {component_id:text(select) 
        {label "[portal_content::conn Component]"} 
	{options {[portal_content::components_get_options]}} 
	{value {[portal_content::conn component_id]}}
    }
    {summary:text 
	{label "[_ portal-content.Summary]"} 
	{html {size 50}}
    }
    {found_in_version:text(select),optional 
        {label "[_ portal-content.Version]"}  
        {options {[portal_content::version_get_options -include_unknown]}} 
        {value {[portal_content::conn user_version_id]}}
    }
    {fix_for_version:text(select),optional 
        {label "Fix For Version"}  
        {options {[portal_content::version_get_options -include_unknown]}} 
        {value {[portal_content::conn user_version_id]}}
    }

    {assign_to:text(select),optional 
        {label "Assign to"}  
        {options {[portal_content::assignee_get_options -workflow_id $workflow_id -include_unknown]}} 
    }

    {return_url:text(hidden) {value $return_url}}
}
foreach {category_id category_name} [portal_content::category_types] {
    ad_form -extend -name content -form [list \
        [list "${category_id}:integer(select)" \
            [list label $category_name] \
            [list options [portal_content::category_get_options -parent_id $category_id]] \
            [list value   [portal_content::get_default_keyword -parent_id $category_id]] \
        ] \
    ]
}


ad_form -extend -name content -form {
    {description:richtext(richtext),optional
        {label "[_ portal-content.Description]"}
        {html {cols 60 rows 13}}
    }

}

ad_form -extend -name content -new_data {

    set keyword_ids [list]
    foreach {category_id category_name} [portal_content::category_types] {
        # -singular not required here since it's a new content
        lappend keyword_ids [element get_value content $category_id]
    }

    portal_content::content::new \
	-content_id $content_id \
	-package_id $package_id \
	-component_id $component_id \
	-found_in_version $found_in_version \
	-summary $summary \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
        -keyword_ids $keyword_ids \
	-fix_for_version $fix_for_version \
	-assign_to $assign_to


} -after_submit {
    portal_content::contents_exist_p_set_true

    ad_returnredirect $return_url
    ad_script_abort
}


if { !$versions_p } {
    element set_properties content found_in_version -widget hidden
}

ad_return_template
