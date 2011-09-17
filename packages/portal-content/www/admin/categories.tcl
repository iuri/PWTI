ad_page_contract {
    Categories
}

set project_name [portal_content::conn project_name]
set page_title "[_ portal-content.Manage_Categories]"
set context_bar [ad_context_bar $page_title]

set package_id [ad_conn package_id]

portal_content::get_pretty_names -array pretty_names

set project_root_keyword_id [portal_content::conn project_root_keyword_id]

db_multirow -extend { 
    edit_url
    delete_url
    new_url
    type_edit_url
    type_delete_url
    contents_url
    set_default_url
} categories select_categories {} {
    # set all the URLs
    set edit_url "category-edit?[export_vars { { keyword_id $child_id } }]"
    if { $num_contents == 0 } {
        set delete_url "category-delete?[export_vars { { keyword_id $child_id } }]"
    } else {
        set delete_url {}
    }
    set new_url "category-edit?[export_vars { parent_id }]"
    
    set type_edit_url "category-edit?[export_vars { { keyword_id $parent_id } { type_p t } }]"
    if { $is_leaf } {
        set type_delete_url "category-delete?[export_vars { { keyword_id $parent_id } }]"
    } else {
        set type_delete_url {}
    }

    if { !$default_p } {
        set set_default_url "category-set-default?[export_vars { parent_id { keyword_id $child_id } }]"
    } else {
        set set_default_url {}
    }
    
    set contents_url "../?[export_vars { { filter.keyword $child_id } { filter.status any } }]"
}

set type_new_url "category-edit"

set default_setup_url "category-defaults"

