ad_library {

    Portal Content Library

    @creation-date 2002-05-03
    @author Lars Pind <lars@collaboraid.biz>
    @cvs-id portal-content-procs.tcl,v 1.13.2.7 2003/03/05 18:13:39 lars Exp

}

namespace eval portal_content {}

ad_proc portal_content::package_key {} {
    return "portal-content"
}

ad_proc portal_content::conn { args } {

    global bt_conn

    set flag [lindex $args 0]
    if { [string index $flag 0] != "-" } {
        set var $flag
        set flag "-get"
    } else {
        set var [lindex $args 1]
    }

    switch -- $flag {
        -set {
            set bt_conn($var) [lindex $args 2]
        }

        -get {
            if { [info exists bt_conn($var)] } {
                return $bt_conn($var)
            } else {
                switch -- $var {
                    content - contents - Bug - Bugs - 
                    component - components - Component - Components -
                    patch - patches - Patch - Patches {
                        if { ![info exists bt_conn($var)] } {
                            get_pretty_names -array bt_conn
                        }
                        return $bt_conn($var)
                    }
                    project_name - project_description - 
                    project_root_keyword_id - project_folder_id - 
                    current_version_id - current_version_name {
                        array set info [get_project_info]
                        foreach name [array names info] {
                            set bt_conn($name) $info($name)
                        }
                        return $bt_conn($var)
                    }
                    user_first_names - user_last_name - user_email - user_version_id - user_version_name {
                        if { [ad_conn user_id] == 0 } {
                            return ""
                        } else {
                            array set info [get_user_prefs]
                            foreach name [array names info] {
                                set bt_conn($name) $info($name)
                            }
                            return $bt_conn($var)
                        }
                    }
                    component_id - 
                    filter - filter_human_readable - 
                    filter_where_clauses - 
                    filter_order_by_clause - filter_from_content_clause {
                        return {}
                    }
                    default {
                        error "[_ portal-content.Unknown_variable]"
                    }
                }
            }
        }

        default {
            error "[_ portal-content.Unknown_flag]"
        }
    }
}

ad_proc portal_content::get_pretty_names { 
    -array:required
} {
    upvar $array row

    set row(content) [lang::util::localize [parameter::get -parameter "TicketPrettyName" -default "content"]]
    set row(contents) [lang::util::localize [parameter::get -parameter "TicketPrettyPlural" -default "contents"]]
    set row(Bug) [string totitle $row(content)]
    set row(Bugs) [string totitle $row(contents)]

    set row(component) [lang::util::localize [parameter::get -parameter "ComponentPrettyName" -default "component"]]
    set row(components) [lang::util::localize [parameter::get -parameter "ComponentPrettyPlural" -default "components"]]
    set row(Component) [string totitle $row(component)]
    set row(Components) [string totitle $row(components)]

    set row(patch) [lang::util::localize [parameter::get -parameter "PatchPrettyName" -default "patch"]]
    set row(patches) [lang::util::localize [parameter::get -parameter "PatchPrettyPlural" -default "patches"]]
    set row(Patch) [string totitle $row(patch)]
    set row(Patches) [string totitle $row(patches)]
}

ad_proc portal_content::get_content_id {
    {-content_number:required}
    {-project_id:required}
} {
    return [db_string content_id {}]
}


ad_proc portal_content::get_page_variables { 
    {extra_spec ""}
} {
    Adds the content listing filter variables for use in the page contract.
    
    ad_page_contract { doc } [portal_content::get_page_variables { foo:integer { bar "" } }]
} {
    set filter_vars {
        page:optional
        f_state:optional
        f_fix_for_version:optional
        f_component:optional
        orderby:optional
        {format "table"}
    }
    foreach { parent_id parent_heading } [portal_content::category_types] {
        lappend filter_vars "f_category_$parent_id:optional"
    }
    foreach action_id [workflow::get_actions -workflow_id [portal_content::content::get_instance_workflow_id]] {
        lappend filter_vars "f_action_$action_id:optional"
    }

    return [concat $filter_vars $extra_spec]
}

ad_proc portal_content::get_export_variables { 
    {extra_vars ""}
} {
    Gets a list of variables to export for the content list
} {
    set export_vars {
        f_state
        f_fix_for_version
        f_component
        orderby
        format
        page
    }
    foreach { parent_id parent_heading } [portal_content::category_types] {
        lappend export_vars "f_category_$parent_id"
    }
    foreach action_id [workflow::get_actions -workflow_id [portal_content::content::get_instance_workflow_id]] {
        lappend export_vars "f_action_$action_id"
    }

    return [concat $export_vars $extra_vars]
}

#####
#
# Cached project info procs
# 
#####

ad_proc portal_content::get_project_info_internal {
    package_id
} {
    db_1row project_info {} -column_array result
    
    return [array get result]
}

ad_proc portal_content::get_project_info {
    -package_id
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }

    return [util_memoize [list portal_content::get_project_info_internal $package_id]]
}

ad_proc portal_content::get_project_info_flush {
    -package_id
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }

    util_memoize_flush [list portal_content::get_project_info_internal $package_id]
}

ad_proc portal_content::set_project_name {
    -package_id
    project_name
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    db_dml project_name_update {}
    
    # Flush cache
    util_memoize_flush [list portal_content::get_project_info_internal $package_id]]
}
   


#####
#
# Stats procs
#
#####
 

ad_proc -public portal_content::contents_exist_p {
    {-package_id {}}
} {
    Returns whether any contents exist in a project
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    return [util_memoize [list portal_content::contents_exist_p_not_cached -package_id $package_id]]
}
    
ad_proc -public portal_content::contents_exist_p_set_true {
    {-package_id {}}
} {
    Sets content_exists_p true. Useful for when you add a new content, so you know that a content will exist.
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    return [util_memoize_seed [list portal_content::contents_exist_p_not_cached -package_id $package_id] 1]
}
    
ad_proc -public portal_content::contents_exist_p_not_cached {
    -package_id:required
} {
    Returns whether any contents exist in a project. Not cached.
} {
    return [db_string select_contents_exist_p {} -default 0]
}
    
    
    
#####
#
# Cached user prefs procs
#
#####

ad_proc portal_content::get_user_prefs_internal {
    package_id
    user_id
} {
    set found_p [db_0or1row user_info { } -column_array result]

    if { !$found_p } {
        set count [db_string count_user_prefs {}]
        if { $count == 0 } {
            db_dml create_user_prefs {}
            # we call ourselves again, so we'll get the info this time
            return [get_user_prefs_internal $package_id $user_id]
        } else {
            error "[_ portal-content.No_user_in_database]"
        }
    } else {
        return [array get result]
    }
}

ad_proc portal_content::get_user_prefs {
    -package_id
    -user_id
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }

    if { ![info exists user_id] } {
        set user_id [ad_conn user_id]
    }

    return [util_memoize [list portal_content::get_user_prefs_internal $package_id $user_id]]
}

ad_proc portal_content::get_user_prefs_flush {
    -package_id
    -user_id
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }

    if { ![info exists user_id] } {
        set user_id [ad_conn user_id]
    }

    util_memoize_flush [list portal_content::get_user_prefs_internal $package_id $user_id]
}
    
    
#####
#
# Status
#
#####

ad_proc portal_content::status_get_options {
    {-package_id ""}
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }

    set workflow_id [portal_content::content::get_instance_workflow_id -package_id $package_id]
    set state_ids [workflow::fsm::get_states -workflow_id $workflow_id]

    set option_list [list]
    foreach state_id $state_ids {
        workflow::state::fsm::get -state_id $state_id -array state
        lappend option_list [list "$state(pretty_name)" $state(short_name)]
    }

    return $option_list
}

ad_proc portal_content::status_pretty {
    status
} {
    set workflow_id [portal_content::content::get_instance_workflow_id]
    if { [catch {set state_id [workflow::state::fsm::get_id -workflow_id $workflow_id -short_name $status]} error] } {
        return ""
    }

    workflow::state::fsm::get -state_id $state_id -array state
    
    return $state(pretty_name)
}

ad_proc portal_content::patch_status_get_options {} {
    return \
        [list \
             [list "[_ portal-content.Open]" open ] \
             [list "[_ portal-content.Accepted]" accepted ] \
             [list "[_ portal-content.Refused]" refused ] \
             [list "[_ portal-content.Deleted]" deleted ] \
            ]
}

ad_proc portal_content::patch_status_pretty {
    status
} {
    array set status_codes {
        open      portal-content.Open
        accepted  portal-content.Accepted
        refused   portal-content.Refused 
        deleted   portal-content.Deleted
    }
    if { [info exists status_codes($status)] } {
        return [_ $status_codes($status)]
    } else {
        return {}
    }
}

#####
#
# Resolution
#
#####

ad_proc portal_content::resolution_get_options {} {
    return \
        [list \
             [list [_ portal-content.Fixed] fixed ] \
             [list [_ portal-content.By_Design] bydesign ] \
             [list [_ portal-content.Wont_Fix] wontfix ] \
             [list [_ portal-content.Postponed] postponed ] \
             [list [_ portal-content.Duplicate] duplicate ] \
             [list [_ portal-content.Not_Reproducable] norepro ] \
             [list [_ portal-content.Need_Info] needinfo ] \
            ]

}

ad_proc portal_content::resolution_pretty {
    resolution
} {
    array set resolution_codes {
        fixed portal-content.Fixed
        bydesign portal-content.By_Design
        wontfix portal-content.Wont_Fix
        postponed portal-content.Postponed
        duplicate portal-content.Duplicate
        norepro portal-content.Not_Reproducable
        needinfo portal-content.Need_Info
    }
    if { [info exists resolution_codes($resolution)] } {
        return [_ $resolution_codes($resolution)]
    } else {
        return ""
    }
}

#####
#
# Categories/Keywords
#
#####

ad_proc portal_content::category_parent_heading {
    {-package_id ""}
    -keyword_id:required
} {
    return [portal_content::category_parent_element -package_id $pcakage_id -keyword_id $keyword_id -element heading]
}

# TODO: This could be made faster if we do a reverse mapping array from child to parent

ad_proc portal_content::category_parent_element {
    {-package_id ""}
    -keyword_id:required
    {-element "heading"}
} {
    foreach elm [get_keywords -package_id $package_id] {
        set child_id [lindex $elm 0]

        if { $child_id == $keyword_id } {
            set parent(id) [lindex $elm 2]
            set parent(heading) [lindex $elm 3]
            return $parent($element)
        }
    }
}

ad_proc portal_content::category_heading {
    {-package_id ""}
    -keyword_id:required
} {
    foreach elm [get_keywords -package_id $package_id] {
        set child_id [lindex $elm 0]
        set child_heading [lindex $elm 1]
        set parent_id [lindex $elm 2]
        set parent_heading [lindex $elm 3]
 
        if { $child_id == $keyword_id } {
            return $child_heading
        } elseif { $parent_id == $keyword_id } {
            return $parent_heading
        }
    }
}

ad_proc portal_content::category_types {
    {-package_id ""}
} {
    @return Returns the category types for this instance as an
    array-list of { parent_id1 heading1 parent_id2 heading2 ... }
} {
    array set heading [list]
    set parent_ids [list]
    
    set last_parent_id {}
    foreach elm [get_keywords -package_id $package_id] {
        set child_id [lindex $elm 0]
        set child_heading [lindex $elm 1]
        set parent_id [lindex $elm 2]
        set parent_heading [lindex $elm 3]
 
        if { $parent_id != $last_parent_id } {
            set heading($parent_id) $parent_heading
            lappend parent_ids $parent_id
            set last_parent_id $parent_id
        }
    }
    
    set result [list]
    foreach parent_id $parent_ids {
        lappend result $parent_id $heading($parent_id)
    }
    return $result
}

ad_proc portal_content::category_get_filter_data_not_cached {
    {-package_id:required}
    {-parent_id:required}
} {
    @param package_id The package (project) to select from
    @param parent_id The category type's keyword_id
    @return list-of-lists with category data for filter
} {
    return [db_list_of_lists select {}]
}

ad_proc portal_content::category_get_filter_data {
    {-package_id:required}
    {-parent_id:required}
} {
    @param package_id The package (project) to select from
    @param parent_id The category type's keyword_id
    @return list-of-lists with category data for filter
} {
    return [util_memoize [list portal_content::category_get_filter_data_not_cached \
                             -package_id $package_id \
                             -parent_id $parent_id]]
}


ad_proc portal_content::category_get_options {
    {-package_id ""}
    {-parent_id:required}
} {
    @param parent_id The category type's keyword_id
    @return options-list for a select widget for the given category type
} {
    set options [list]
    foreach elm [get_keywords -package_id $package_id] {
        set elm_child_id [lindex $elm 0]
        set elm_child_heading [lindex $elm 1]
        set elm_parent_id [lindex $elm 2]
 
        if { $elm_parent_id == $parent_id } {
            lappend options [list $elm_child_heading $elm_child_id]
        }
    }
    return $options
}


## Cache maintenance

ad_proc -private portal_content::get_keywords {
    {-package_id ""}
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [util_memoize [list portal_content::get_keywords_not_cached -package_id $package_id]]
}

ad_proc -private portal_content::get_keywords_flush {
    {-package_id ""}
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    util_memoize_flush [list portal_content::get_keywords_not_cached -package_id $package_id]
}

ad_proc -private portal_content::get_keywords_not_cached {
    -package_id:required
} {
    return [db_list_of_lists select_package_keywords {}]
}





ad_proc -public portal_content::set_default_keyword {
    {-package_id ""}
    {-parent_id:required}
    {-keyword_id:required}
} {
    Set the default keyword for a given type (parent)
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    db_dml delete_existing { 
        delete
        from   bt_default_keywords 
        where  project_id = :package_id 
        and    parent_id = :parent_id
    }
    
    db_dml insert_new { 
        insert into bt_default_keywords (project_id, parent_id, keyword_id)
        values (:package_id, :parent_id, :keyword_id)
    }
    get_default_keyword_flush -package_id $package_id -parent_id $parent_id
}

ad_proc -public portal_content::get_default_keyword {
    {-package_id ""}
    {-parent_id:required}
} {
    Get the default keyword for a given type (parent)
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    return [util_memoize [list portal_content::get_default_keyword_not_cached -package_id $package_id -parent_id $parent_id]]
}

ad_proc -public portal_content::get_default_keyword_flush {
    {-package_id ""}
    {-parent_id:required}
} {
    Flush the cache for 
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    util_memoize_flush [list portal_content::get_default_keyword_not_cached -package_id $package_id -parent_id $parent_id]
}


ad_proc -private portal_content::get_default_keyword_not_cached {
    {-package_id:required}
    {-parent_id:required}
} {
    Get the default keyword for a given type (parent), not cached.
} {
    return [db_string default { 
        select keyword_id
        from   bt_default_keywords
        where  project_id = :package_id
        and    parent_id = :parent_id
    } -default {}]
}



ad_proc -public portal_content::get_default_configurations {} {
    Get the package's default configurations for categories and parameters.
} {
    return [list \
        [_ portal-content.Bug_Tracker] [list \
            categories [list \
                "[_ portal-content.Bug_Type]" [list \
                    "[_ portal-content.Bug_Bug_cat]" \
                    "[_ portal-content.Bug_Sug_Cat]" \
                ] \
                "[_ portal-content.Priority]" [list \
                    "[_ portal-content.Prio_High_Cat]" \
                    "[_ portal-content.Prio_Norm_Cat]" \
                    "[_ portal-content.Prio_Low_Cat]" \
                ] \
		"[_ portal-content.Severity]" [list \
                    "[_ portal-content.Sev_Critical_Cat]" \
                    "[_ portal-content.Sev_Major_Cat]" \
                    "[_ portal-content.Sev_Normal_Cat]" \
                    "[_ portal-content.Sev_Minor_Cat]" \
                ] \
            ] \
            parameters {
                TicketPrettyName "content"
                TicketPrettyPlural "contents"
                ComponentPrettyName "component"
                ComponentPrettyPlural "components"
                PatchesP "1"
                VersionsP "1"
            } \
        ] \
        [_ portal-content.Ticket_Tracker] [list \
            categories [list \
                "[_ portal-content.Ticket_Type]" [list \
                    "[_ portal-content.Ticket_Todo_Cat]" \
                    "[_ portal-content.Ticket_Sugg_Cat]" \
                ] \
                "[_ portal-content.Priority]" [list \
                    "[_ portal-content.Prio_High_Cat]" \
                    "[_ portal-content.Prio_Norm_Cat]" \
                    "[_ portal-content.Prio_Low_Cat]" \
                ] \
            ] \
            parameters {
                TicketPrettyName "ticket"
                TicketPrettyPlural "tickets"
                ComponentPrettyName "area"
                ComponentPrettyPlural "areas"
                PatchesP "0" 
                VersionsP "0"
            } \
        ] \
        [_ portal-content.Support_Center] [list \
	    categories [list \
		"[_ portal-content.Message_Type]" [list \
                    "[_ portal-content.Support_Problem]" \
                    "[_ portal-content.Support_Suggestion]" \
                    "[_ portal-content.Support_Error]" \
                ] \
    	        "[_ portal-content.Priority]" [list \
	            "[_ portal-content.Prio_High_Cat]" \
		    "[_ portal-content.Prio_Norm_Cat]" \
		    "[_ portal-content.Prio_Low_Cat]" \
		] \
            ] \
            parameters {
                TicketPrettyName "message"
                TicketPrettyPlural "messages"
                ComponentPrettyName "area"
                ComponentPrettyPlural "areas"
                PatchesP "0" 
                VersionsP "0"
            } \
        ] \
    ]
}






ad_proc -public portal_content::delete_all_project_keywords {
    {-package_id ""}
} {
    Deletes all the keywords in a project
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    db_exec_plsql keywords_delete {}
    portal_content::get_keywords_flush -package_id $package_id
}

ad_proc -public portal_content::install_keywords_setup {
    {-package_id ""}
    -spec:required
} {
    @param spec is an array-list of { Type1 { cat1 cat2 cat3 } Type2 { cat1 cat2 cat3 } }
    Default category within type is denoted by letting the name start with a *, 
    which is removed before creating the keyword.
} {
    set root_keyword_id [portal_content::conn project_root_keyword_id -package_id $package_id]

    foreach { category_type categories } $spec {
        set category_type_id [cr::keyword::get_keyword_id \
                                  -parent_id $root_keyword_id \
                                  -heading $category_type]
        
        if { [empty_string_p $category_type_id] } {
            set category_type_id [cr::keyword::new \
                                      -parent_id $root_keyword_id \
                                      -heading $category_type]
        }
        
        foreach category $categories {
            if { [string equal [string index $category 0] "*"] } {
                set default_p 1
                set category [string range $category 1 end]
            } else {
                set default_p 0
            }                  
            
            set category_id [cr::keyword::get_keyword_id \
                                 -parent_id $category_type_id \
                                 -heading $category]
            
            if { [empty_string_p $category_id] } {
                set category_id [cr::keyword::new \
                                     -parent_id $category_type_id \
                                     -heading $category]
            }

            if { $default_p } {
                portal_content::set_default_keyword \
                    -package_id $package_id \
                    -parent_id $category_type_id \
                    -keyword_id $category_id
            }
        }
    }
    portal_content::get_keywords_flush -package_id $package_id
}

ad_proc -public portal_content::install_parameters_setup {
    {-package_id ""}
    -spec:required
} {
    @param parameters as an array-list of { name value name value ... }
} {
    foreach { name value } $spec {
        parameter::set_value -package_id $package_id -parameter $name -value $value
    }
}



#####
#
# Versions
#
#####

ad_proc portal_content::version_get_options {
    -package_id
    -include_unknown:boolean
    -include_undecided:boolean
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    set versions_list [util_memoize [list portal_content::version_get_options_not_cached $package_id]]

    if { $include_unknown_p } {
        set versions_list [concat [list [list [_ portal-content.Unknown] "" ] ] $versions_list]
    }

    if { $include_undecided_p } {
        set versions_list [concat [list [list [_ portal-content.Undecided] "" ] ] $versions_list]
    }

    return $versions_list
}


ad_proc portal_content::assignee_get_options {
    -workflow_id
    -include_unknown:boolean
    -include_undecided:boolean
} {
    Returns an option list containing all users that have submitted or assigned to a content.
    Used for the add content form. Added because the workflow api requires a case_id.  
    (an item to evaluate is refactoring workflow to provide an assignee widget without a case_id)
} {
   
    set assignee_list [db_list_of_lists assignees {}]

    if { $include_unknown_p } {
        set assignee_list [concat { { "Unknown" "" } } $assignee_list]
    } 
    
    if { $include_undecided_p } {
        set assignee_list [concat { { "Undecided" "" } } $assignee_list]
    } 
    
    return $assignee_list
}


ad_proc portal_content::versions_p {
    {-package_id ""}
} { 
    Is the versions feature turned on?
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    
    return [parameter::get -package_id [ad_conn package_id] -parameter "VersionsP" -default 1]
}


ad_proc portal_content::versions_flush {} {
    set package_id [ad_conn package_id]
    util_memoize_flush [list portal_content::version_get_options_not_cached $package_id]
}

ad_proc portal_content::version_get_options_not_cached {
    package_id
} {
    set versions_list [db_list_of_lists versions {}]
    
    return $versions_list
}



ad_proc portal_content::version_get_name {
    {-package_id ""}
    {-version_id:required}
} {
    if { [empty_string_p $version_id] } {
        return {}
    }
    foreach elm [version_get_options -package_id $package_id] {
        set name [lindex $elm 0]
        set id [lindex $elm 1]
        if { [string equal $id $version_id] } {
            return $name
        }
    }
    error [_ portal-content.Version_id [list version_id $version_id]]
}


#####
#
# Components
#
#####

ad_proc portal_content::component_get_filter_data_not_cached {
    {-package_id:required}
} {
    @param package_id The project we're interested in
    @return list-of-lists with component data for filter
} {
    return [db_list_of_lists select {}]
}

ad_proc portal_content::component_get_filter_data {
    {-package_id:required}
} {
    @param package_id The project we're interested in
    @return list-of-lists with component data for filter
} {
    return [util_memoize [list portal_content::component_get_filter_data_not_cached \
                             -package_id $package_id]]
}
ad_proc portal_content::components_get_options {
    {-package_id ""}
    -include_unknown:boolean
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    set components_list [util_memoize [list portal_content::components_get_options_not_cached $package_id]]

    if { $include_unknown_p } {
        set components_list [concat [list [list "[_ portal-content.Unknown]" {} ]] $components_list]
    } 
    
    return $components_list
}

ad_proc portal_content::components_flush {} {
    set package_id [ad_conn package_id]
    util_memoize_flush [list portal_content::components_get_options_not_cached $package_id]
    util_memoize_flush [list portal_content::components_get_url_names_not_cached -package_id $package_id]
}

ad_proc portal_content::components_get_options_not_cached {
    package_id
} {
    set components_list [db_list_of_lists components {}]

    return $components_list
}

ad_proc portal_content::component_get_name {
    {-package_id ""}
    {-component_id:required}
} {
    if { [empty_string_p $component_id] } {
        return {}
    }
    foreach elm [components_get_options -package_id $package_id] {
        set id [lindex $elm 1]
        if { [string equal $id $component_id] } {
            return [lindex $elm 0]
        }
    }
    error [_ portal-content.Component_id_not_found]
}

ad_proc portal_content::component_get_url_name {
    {-package_id ""}
    {-component_id:required}
} {
    if { [empty_string_p $component_id] } {
        return {}
    }
    foreach { id url_name } [components_get_url_names -package_id $package_id] {
        if { [string equal $id $component_id] } {
            return $url_name
        }
    }
    return {}
}

ad_proc portal_content::components_get_url_names {
    {-package_id ""}
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [util_memoize [list portal_content::components_get_url_names_not_cached -package_id $package_id]]
}

ad_proc portal_content::components_get_url_names_not_cached {
    {-package_id:required}
} {
    db_foreach select_component_url_names {} {
        lappend result $component_id $url_name
    }
    return $result
}


#####
#
# Description (still used by the patch code, to be removed when they've moved to workflow)
#
#####

ad_proc portal_content::content_convert_comment_to_html {
    {-comment:required}
    {-format:required}
} {
    return [ad_html_text_convert -from $format -to text/html -- $comment]
}

ad_proc portal_content::content_convert_comment_to_text {
    {-comment:required}
    {-format:required}
} {
    return [ad_html_text_convert -from $format -to text/plain -- $comment]
}

#####
#
# Actions
#
#####

ad_proc portal_content::patch_action_pretty {
    action
} {

    array set action_codes {
        open portal-content.Opened
        edit portal-content.Edited
        comment portal-content.Comment
        accept portal-content.Accepted
        reopen portal-content.Reopened
        refuse portal-content.Refused
        delete portal-content.Deleted
    }

    if { [info exists action_codes($action)] } {
        return [_ $action_codes($action)]
    } else {
        return ""
    }
}

#####
#
# Maintainers
#
#####

ad_proc ::portal_content::users_get_options {
    -package_id
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    set user_id [ad_conn user_id]
    
    # This picks out users who are already assigned to some content in this
    set sql {
        select first_names || ' ' || last_name || ' (' || email || ')'  as name, 
               user_id
        from   cc_users
        where  user_id in (
                      select maintainer
                      from   bt_projects
                      where  project_id = :package_id
                      
                      union
                      
                      select maintainer
                      from   bt_versions
                      where  project_id = :package_id
                      
                      union
                      
                      select maintainer
                      from   bt_components
                      where  project_id = :package_id
                )
        or     user_id = :user_id
        order  by name
    }
    
    set users_list [db_list_of_lists users $sql]
    
    set users_list [concat [list [list [_ portal-content.Unassigned] "" ]] $users_list]
    lappend users_list [list [_ portal-content.Search] ":search:"]

    return $users_list
}


#####
#
# Patches
#
#####

ad_proc portal_content::patches_p {} { 
    Is the patch submission feature turned on?
} {
    return [parameter::get -package_id [ad_conn package_id] -parameter "PatchesP" -default 1]
}

ad_proc portal_content::map_patch_to_content {
    {-patch_id:required}
    {-content_id:required}
} {
    db_dml map_patch_to_content {}
}

ad_proc portal_content::unmap_patch_from_content {
    {-patch_number:required}
    {-content_number:required}
} {
    set package_id [ad_conn package_id]
    db_dml unmap_patch_from_content {}
}

ad_proc portal_content::get_mapped_contents {
    {-patch_number:required}
    {-only_open_p "0"}
} {
    Return a list of lists with the content number in the first element and the content
    summary in the second.
} {
    set content_list [list]
    set package_id [ad_conn package_id]

    if { $only_open_p } {
        set workflow_id [portal_content::content::get_instance_workflow_id]
        set initial_state [workflow::fsm::get_initial_state -workflow_id $workflow_id]

        set open_clause "\n        and exists (select 1 
                                               from workflow_cases cas, 
                                                    workflow_case_fsm cfsm 
                                               where cas.case_id = cfsm.case_id 
                                                 and cas.object_id = b.content_id 
                                                 and cfsm.current_state = :initial_state)"
    } else {
        set open_clause ""
    }

    db_foreach get_contents_for_patch {} {
        lappend content_list [list "[portal_content::conn Bug] #$content_number: $summary" "$content_number"]
    }

    return $content_list
}

ad_proc portal_content::get_content_links {
    {-patch_id:required}
    {-patch_number:required}
    {-write_or_submitter_p:required}
} {
    set content_list [get_mapped_contents -patch_number $patch_number]
    set content_link_list [list]

    if { [llength $content_list] == "0"} {
        return ""
    } else {
        
        foreach content_item $content_list {

            set content_number [lindex $content_item 1]
            set content_summary [lindex $content_item 0]

            set unmap_url "unmap-patch-from-content?[export_vars -url { patch_number content_number } ]"
            if { $write_or_submitter_p } {
                set unmap_link "(<a href=\"$unmap_url\">[_ portal-content.unmap]</a>)"
            } else {
                set unmap_link ""
            }
            lappend content_link_list "<a href=\"content?content_number=$content_number \">$content_summary</a> $unmap_link"
        } 

        if { [llength $content_link_list] != 0 } {
            set contents_string [join $content_link_list "<br>"]
        } else {
	    set contents_name [portal_content::conn contents]
            set contents_string [_ portal-content.No_Bugs]
        }

        return $contents_string
    }
}

ad_proc portal_content::get_patch_links {
    {-content_id:required}
    {-show_patch_status open}
} {
    set patch_list [list]

    switch -- $show_patch_status {
        open {
            set status_where_clause "and bt_patches.status = :show_patch_status"
        }
        all {
            set status_where_clause ""
        }
    }

    db_foreach get_patches_for_content "" {
        
        set status_indicator [ad_decode $show_patch_status "all" "($status)" ""]
        lappend patch_list "<a href=\"patch?patch_number=$patch_number\" title=\"patch $patch_number\">[ad_quotehtml $summary]</a> $status_indicator"
    } if_no_rows { 
	set patches_name [portal_content::conn patches]
        set patches_string [_ portal-content.No_patches]
    }

    if { [llength $patch_list] != 0 } {
        set patches_string [join $patch_list ",&nbsp;"]
    }

    return $patches_string
}

ad_proc portal_content::get_patch_submitter {
    {-patch_number:required}
} {
    set package_id [ad_conn package_id]
    return [db_string patch_submitter_id {}] 
}

ad_proc portal_content::update_patch_status {
    {-patch_number:required}
    {-new_status:required}
} {
    set package_id [ad_conn package_id]
    db_dml update_patch_status ""
}

ad_proc portal_content::get_uploaded_patch_file_content {
    
} {
    set patch_file [ns_queryget patch_file]
   
    if { [empty_string_p $patch_file] } {
        # No patch file was uploaded
        return ""
    }

    set tmp_file [ns_queryget patch_file.tmpfile]
    set tmp_file_channel [open $tmp_file r]
    set content [read $tmp_file_channel]

    return $content
}

ad_proc portal_content::security_violation {
    -user_id:required
    -content_id:required
    -action_id:required
} {
    workflow::action::get -action_id $enabled_action(action_id) -array action
    portal_content::content::get -content_id $content_id -array content

    ns_log notice "portal_content::security_violation: $user_id doesn't have permission to '$action(pretty_name)' on content $content(summary)"
    ad_return_forbidden \
        [_ portal-content.Permission_Denied] \
        "<blockquote>[_ portal-content.No_Permission_to_do_action]</blockquote>"
    ad_script_abort
}


#####
#
# Projects
#
#####


ad_proc portal_content::project_delete { project_id } {
    Delete a Portal Content project and all its data.

    @author Peter Marklund
} {
    #manually delete all contents to avoid wierd integrity constraints
    while { [set content_id [db_string min_content_id {}]] > 0 } {
        portal_content::content::delete $content_id
    }
    db_exec_plsql delete_project {}
}

ad_proc portal_content::project_new { project_id } {
    Create a new Portal Content project for a package instance.

    @author Peter Marklund
} {

    if {![db_0or1row already_there {select 1 from bt_projects where  project_id = :project_id} ] } {
	if [db_0or1row instance_info { *SQL* } ] {
	    set folder_id [content::folder::new -name "portal_content_$project_id" -package_id $project_id]
	    content::folder::register_content_type -folder_id $folder_id -content_type {bt_content_revision} -include_subtypes t
	    
	    set keyword_id [content::keyword::new -heading "$instance_name"]
	    
	    # Inserts into bt_projects
	    set component_id [db_nextval acs_object_id_seq]
	    db_dml bt_projects_insert {}
	    db_dml bt_components_insert {}
	}
    }
}

ad_proc portal_content::version_get_filter_data_not_cached {
    {-package_id:required}
} {
    @param package_id The package (project) to select from
    @return list-of-lists with fix-for-version data for filter
} {
    return [db_list_of_lists select {}]
}

ad_proc portal_content::version_get_filter_data {
    {-package_id:required}
} {
    @param package_id The package (project) to select from
    @return list-of-lists with fix-for-version data for filter
} {
    return [util_memoize [list portal_content::version_get_filter_data_not_cached \
                             -package_id $package_id]] 
}

ad_proc portal_content::assignee_get_filter_data_not_cached {
    {-package_id:required}
    {-workflow_id:required}
    {-action_id:required}
} {
    @param package_id The package (project) to select from
    @param workflow_id The workflow we're interested in
    @param action_id The action we're interested in
    @return list-of-lists with assignee data for filter
} {
    return [db_list_of_lists select {}]
}

ad_proc portal_content::assignee_get_filter_data {
    {-package_id:required}
    {-workflow_id:required}
    {-action_id:required}
} {
    @param package_id The package (project) to select from
    @param workflow_id The workflow we're interested in
    @param action_id The action we're interested in
    @return list-of-lists with assignee data for filter
} {
    return [util_memoize [list portal_content::assignee_get_filter_data_not_cached \
                             -package_id $package_id \
                             -workflow_id $workflow_id \
                             -action_id $action_id]] 
}

ad_proc portal_content::state_get_filter_data_not_cached {
    {-package_id:required}
    {-workflow_id:required}
} {
    @param package_id The package (project) to select from
    @param workflow_id The workflow we're interested in
    @return list-of-lists with state data for filter
} {
    return [db_list_of_lists select {}]
}

ad_proc portal_content::state_get_filter_data {
    {-package_id:required}
    {-workflow_id:required}
} {
    @param package_id The package (project) to select from
    @param workflow_id The workflow we're interested in
    @return list-of-lists with state data for filter
} {
    return [util_memoize [list portal_content::state_get_filter_data_not_cached \
                             -package_id $package_id \
                             -workflow_id $workflow_id]]
}
