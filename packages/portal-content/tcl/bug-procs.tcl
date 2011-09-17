ad_library {

    Portal Content Bug Library
    
    Procedures that deal with a single content

    @creation-date 2003-01-10
    @author Lars Pind <lars@collaboraid.biz>
    @cvs-id $Id: content-procs.tcl,v 1.21 2005/02/24 13:33:03 jeffd Exp $

}

namespace eval portal_content::content {}

namespace eval portal_content::content::capture_resolution_code {}
namespace eval portal_content::content::format_log_title {}
namespace eval portal_content::content::get_component_maintainer {}
namespace eval portal_content::content::get_project_maintainer {}
namespace eval portal_content::content::notification_info {}

ad_proc -public portal_content::content::cache_flush {
    -content_id:required
} {
    Flush all list builder instances and other appropriate things for the given portal-content
    package instance.
} {
    set project_id [db_string get_project_id {}]
    cache flush "contents,project_id=$project_id,*"
    util_memoize_flush_regexp -log "^portal_content::.*_get_filter_data_not_cached -package_id $project_id"
}

ad_proc -public portal_content::content::workflow_short_name {} {
    Get the short name of the workflow for contents
} {
    return "content"
}

ad_proc -public portal_content::content::object_type {} {
    Get the short name of the workflow for contents
} {
    return "bt_content"
}

ad_proc -public portal_content::content::get {
    {-content_id:required}
    {-array:required}
    {-enabled_action_id {}}
} {
    Get the fields for a content
} {
    # Select the info into the upvar'ed Tcl Array
    upvar $array row

    db_1row select_content_data {} -column_array row
    
    # Get the case ID, so we can get state information
    set case_id [workflow::case::get_id \
                     -object_id $content_id \
                     -workflow_short_name [portal_content::content::workflow_short_name]]
    
    # Derived fields
    set row(content_number_display) "$row(content_number)"
    set row(component_name) [portal_content::component_get_name -component_id $row(component_id) -package_id $row(project_id)]
    set row(found_in_version_name) [portal_content::version_get_name -version_id $row(found_in_version) -package_id $row(project_id)]
    set row(fix_for_version_name) [portal_content::version_get_name -version_id $row(fix_for_version) -package_id $row(project_id)]
    set row(fixed_in_version_name) [portal_content::version_get_name -version_id $row(fixed_in_version) -package_id $row(project_id)]
    
    # Get state information
    workflow::case::fsm::get -case_id $case_id -array case -enabled_action_id $enabled_action_id
    set row(pretty_state) $case(pretty_state)
    if { ![empty_string_p $row(resolution)] } {
        append row(pretty_state) " ([portal_content::resolution_pretty $row(resolution)])"
    }
    set row(state_short_name) $case(state_short_name)
    set row(hide_fields) $case(state_hide_fields)
    set row(entry_id) $case(entry_id)
}

ad_proc -public portal_content::content::insert {
    -content_id:required
    -package_id:required
    -component_id:required
    -found_in_version:required
    -summary:required
    -description:required
    -desc_format:required
    {-user_agent ""}
    {-user_id ""}
    {-ip_address ""}
    {-item_subtype "bt_content"}
    {-content_type "bt_content_revision"}
    {-fix_for_version ""}
    {-assign_to ""}
} {
    Inserts a new content into the content repository.
    You probably don't want to run this yourself - to create a new content, use portal_content::content::new
    and let it do the hard work for you.

    @see portal_content::content::new
    @return content_id The same content_id passed in, just for convenience.
    
} {
    if { ![exists_and_not_null user_agent] } {
        set user_agent [ns_set get [ns_conn headers] "User-Agent"]
    }

    set comment_content $description
    set comment_format $desc_format

    if { ![exists_and_not_null creation_date] } {
        set creation_date [db_string select_sysdate {}]
    }

    set extra_vars [ns_set create]
    oacs_util::vars_to_ns_set \
        -ns_set $extra_vars \
        -var_list { content_id package_id component_id found_in_version summary user_agent comment_content comment_format creation_date fix_for_version assign_to}


    set content_id [package_instantiate_object \
                    -creation_user $user_id \
                    -creation_ip $ip_address \
                    -extra_vars $extra_vars \
                    -package_name "bt_content" \
                    "bt_content"]

    cache_flush -content_id $content_id
    
    return $content_id
}

ad_proc -public portal_content::content::new {
    -content_id:required
    -package_id:required
    -component_id:required
    -found_in_version:required
    -summary:required
    -description:required
    -desc_format:required
    {-user_agent ""}
    {-user_id ""}
    {-ip_address ""}
    {-item_subtype "bt_content"}
    {-content_type "bt_content_revision"}
    {-keyword_ids {}}
    {-fix_for_version {}}
    {-assign_to ""}
} {
    Create a new content, then send out notifications, starts workflow, etc.

    Calls portal_content::content::insert.
    
    @see portal_content::content::insert.
    @return content_id The same content_id passed in, just for convenience.
} {
   

    db_transaction {

        set content_id [portal_content::content::insert \
                -content_id $content_id \
                -package_id $package_id \
                -component_id $component_id \
                -found_in_version $found_in_version \
                -summary $summary \
                -description $description \
                -desc_format $desc_format \
                -user_agent $user_agent \
                -user_id $user_id \
                -ip_address $ip_address \
                -item_subtype $item_subtype \
                -content_type $content_type \
		-fix_for_version $fix_for_version ]

        foreach keyword_id $keyword_ids {
            cr::keyword::item_assign -item_id $content_id -keyword_id $keyword_id
        }
	
	if {![empty_string_p $assign_to]} {

	    array set assign_array [list resolver $assign_to]
	    
	} else {
	    array set assign_array ""
	}

	
        set case_id [workflow::case::new \
                -workflow_id [workflow::get_id -object_id $package_id -short_name [workflow_short_name]] \
                -object_id $content_id \
                -comment $description \
                -comment_mime_type $desc_format \
		-user_id $user_id \
		-assignment [array get assign_array]]
    
    return $content_id
    }
}


ad_proc -public portal_content::content::update {
    -content_id:required
    {-user_id ""}
    {-creation_ip ""}
    -array:required
} {
    Update a content in the DB. Usually, you'll want to use portal_content::content::edit 
    because that one sends out notifications, etc.

    @see portal_content::content::edit
    @return content_id The same content_id passed in, just for convenience.
} {
    upvar $array row

    if { ![exists_and_not_null user_id] } {
        set user_id [ad_conn user_id]
    }

    get -content_id $content_id -array new_row

    foreach column [array names row] {
        set new_row($column) $row($column)
    }
    set new_row(creation_user) $user_id
    set new_row(creation_ip) $creation_ip

    foreach name [array names new_row] {
        set $name $new_row($name)
    }
    set revision_id [db_exec_plsql update_content {}]

    cache_flush -content_id $content_id

    return $content_id
}



ad_proc -public portal_content::content::edit {
    -content_id:required
    -enabled_action_id:required
    {-user_id ""}
    {-creation_ip ""}
    -description:required
    -desc_format:required
    -array:required
    {-entry_id {}}
} {
    Edit a content, then send out notifications, etc.

    Calls portal_content::content::update.
   
    @see portal_content::content::update
    @return content_id The same content_id passed in, just for convenience.
} {
    upvar $array row
    
    array set assignments [list]
    
    set role_prefix "role_"
    foreach name [array names row "${role_prefix}*"] {
        set assignments([string range $name [string length $role_prefix] end]) $row($name)
        unset row($name)
    }
    
    db_transaction {
        # Update the content info
        update \
                -content_id $content_id \
                -user_id $user_id \
                -creation_ip $creation_ip \
                -array row

        # Update the keywords
        foreach {category_id category_name} [portal_content::category_types] {
            if { [exists_and_not_null row($category_id)] } {
                cr::keyword::item_assign -singular -item_id $content_id -keyword_id $row($category_id)
            }
            # LARS:
            # We don't unassign if no value is supplied for one of the categories
            # we just leave them untouched.
        }

        set case_id [workflow::case::get_id \
                -workflow_short_name [workflow_short_name] \
                -object_id $content_id]

        # Assignments
        workflow::case::role::assign \
                -replace \
                -case_id $case_id \
                -array assignments
        
        workflow::case::action::execute \
                -enabled_action_id $enabled_action_id \
                -comment $description \
                -comment_mime_type $desc_format \
                -user_id $user_id \
                -entry_id $entry_id

    }
    return $content_id
}


ad_proc portal_content::content::delete { content_id } {
    Delete a Portal Content content.
    This should only ever be run when un-instantiating a project!

    @author Mark Aufflick
} {

    # Probably not necessary if developers follow the instructions in the
    # header comment ...
    cache_flush -content_id $content_id

    set case_id [db_string get_case_id {}]
    db_exec_plsql delete_content_case {}
    set notifications [db_list get_notifications {}]
    foreach notification_id $notifications {
        db_exec_plsql delete_notification {}
    }
    db_dml unset_revisions {}
    db_exec_plsql delete_cr_item {}
}


ad_proc -public portal_content::content::get_watch_link {
    {-content_id:required}
} {
    Get link for watching a content.
    @return 3-tuple of url, label and title.
} {
    set user_id [ad_conn user_id]
    set return_url [ad_return_url]
    
    # Get the type id
    set type "workflow_case"
    set type_id [notification::type::get_type_id -short_name $type]
    # get some i18n text
    set content_name "[portal_content::conn content]"

    # Check if subscribed
    set request_id [notification::request::get_request_id \
                        -type_id $type_id \
                        -object_id $content_id \
                        -user_id $user_id]

    set subscribed_p [expr ![empty_string_p $request_id]]
        
    if { !$subscribed_p } {
        set url [notification::display::subscribe_url \
                     -type $type \
                     -object_id $content_id \
                     -url $return_url \
                     -user_id $user_id \
                     -pretty_name "[_ portal-content.this_content]"]
        set label "[_ portal-content.watch_this_content]"
        set title "[_ portal-content.request_notification_for_content]"
    } else {
        set url [notification::display::unsubscribe_url -request_id $request_id -url $return_url]
        set label "[_ portal-content.stop_watching_content]"
        set title "[_ portal-content.unsubscribe_to_content]"
    }
    return [list $url $label $title]
}

ad_proc -private portal_content::content::workflow_create {} {
    Create the 'content' workflow for portal-content
} {
    set spec {
        content {
            pretty_name "#portal-content.Bug#"
            package_key "portal-content"
            object_type "bt_content"
            callbacks { 
                portal-content.FormatLogTitle 
                portal-content.BugNotificationInfo
            }
            roles {
                submitter {
                    pretty_name "#portal-content.Submitter#"
		    callbacks { 
                        workflow.Role_DefaultAssignees_CreationUser
                    }
                }
                resolver {
                    pretty_name "#portal-content.Resolver#"
                    callbacks {
                        portal-content.ComponentMaintainer
                        portal-content.ProjectMaintainer
                        workflow.Role_PickList_CurrentAssignees
                        workflow.Role_AssigneeSubquery_RegisteredUsers
                    }
                }
            }
            states {
                open {
                    pretty_name "#portal-content.state_open#"
                    hide_fields { resolution fixed_in_version }
                }
                resolved {
                    pretty_name "#portal-content.Resolved#"
                }
                closed {
                    pretty_name "#portal-content.Closed#"
                }
            }
            actions {
                open {
                    pretty_name "#portal-content.action_open#"
                    pretty_past_tense "#portal-content.Opened#"
                    new_state open
                    initial_action_p t
                }
                comment {
                    pretty_name "#portal-content.Comment#"
                    pretty_past_tense "#portal-content.Commented#"
                    allowed_roles { submitter resolver }
                    privileges { read write }
                    always_enabled_p t
                }
                edit {
                    pretty_name "#acs-kernel.common_Edit#"
                    pretty_past_tense "#portal-content.Edited#"
                    allowed_roles { submitter resolver }
                    privileges { write }
                    always_enabled_p t
                    edit_fields { 
                        component_id 
                        summary 
                        found_in_version
                        role_resolver
                        fix_for_version
                        resolution 
                        fixed_in_version 
                    }
                }
                reassign {
                    pretty_name "#portal-content.Reassign#"
                    pretty_past_tense "#portal-content.Reassigned#"
                    allowed_roles { submitter resolver }
                    privileges { write }
                    enabled_states { resolved }
                    assigned_states { open }
                    edit_fields { role_resolver }
                }
                resolve {
                    pretty_name "#portal-content.Resolve#"
                    pretty_past_tense "#portal-content.Resolved#"
                    assigned_role resolver
                    enabled_states { resolved }
                    assigned_states { open }
                    new_state resolved
                    privileges { write }
                    edit_fields { resolution fixed_in_version }
                    callbacks { portal-content.CaptureResolutionCode }
                }
                close {
                    pretty_name "#portal-content.Close#"
                    pretty_past_tense "#portal-content.Closed#"
                    assigned_role submitter
                    assigned_states { resolved }
                    new_state closed
                    privileges { write }
                }
                reopen {
                    pretty_name "#portal-content.Reopen#"
                    pretty_past_tense "#portal-content.Reopened#"
                    allowed_roles { submitter }
                    enabled_states { resolved closed }
                    new_state open
                    privileges { write }
                }
            }
        }
    }

    set workflow_id [workflow::fsm::new_from_spec -spec $spec]
    
    return $workflow_id
}

ad_proc -private portal_content::content::workflow_delete {} {
    Delete the 'content' workflow for portal-content
} {
    set workflow_id [get_package_workflow_id]
    if { ![empty_string_p $workflow_id] } {
        workflow::delete -workflow_id $workflow_id
    }
}

ad_proc -public portal_content::content::get_package_workflow_id {} { 
    Return the workflow_id for the package (not instance) workflow
} {
    return [workflow::get_id \
            -short_name [workflow_short_name] \
            -package_key [portal_content::package_key]]

}


ad_proc -public portal_content::content::get_instance_workflow_id {
    {-package_id {}}
} { 
    Return the workflow_id for the package (not instance) workflow
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }

    return [workflow::get_id \
            -short_name [workflow_short_name] \
            -object_id $package_id]
}

ad_proc -private portal_content::content::instance_workflow_create {
    {-package_id:required}
} {
    Creates a clone of the default portal-content package workflow for a
    specific package instance 
} {
    set workflow_id [workflow::fsm::clone \
            -workflow_id [get_package_workflow_id] \
            -object_id $package_id]
    
    return $workflow_id
}

ad_proc -private portal_content::content::instance_workflow_delete {
    {-package_id:required}
} {
    Deletes the instance workflow
} {
    workflow::delete -workflow_id [get_instance_workflow_id -package_id $package_id]
}




#####
#
# Capture resolution code
#
#####

ad_proc -private portal_content::content::capture_resolution_code::pretty_name {} {
    return "[_ portal-content.Capture]"
}

ad_proc -private portal_content::content::capture_resolution_code::do_side_effect {
    case_id
    object_id
    action_id
    entry_id
} {
    workflow::case::add_log_data \
        -entry_id $entry_id \
        -key resolution \
        -value [db_string select_resolution_code {}]
}

#####
#
# Format log title
#
#####

ad_proc -private portal_content::content::format_log_title::pretty_name {} {
    return "[_ portal-content.Add_3]"
}

ad_proc -private portal_content::content::format_log_title::format_log_title {
    case_id
    object_id
    action_id
    entry_id
    data_arraylist
} {
    array set data $data_arraylist

    if { [info exists data(resolution)] } {
        return [portal_content::resolution_pretty $data(resolution)]
    } else {
        return {}
    }
}

#####
#
# Get component maintainer
#
#####

ad_proc -private portal_content::content::get_component_maintainer::pretty_name {} {
    return "[_ portal-content.Bug-tracker]"
}

ad_proc -private portal_content::content::get_component_maintainer::get_assignees {
    case_id
    object_id
    role_id
} {
    return [db_string select_component_maintainer {} -default {}]
}

#####
#
# Project maintainer
#
#####

ad_proc -private portal_content::content::get_project_maintainer::pretty_name {} {
    return "[_ portal-content.Bug-tracker_1]"
}

ad_proc -private portal_content::content::get_project_maintainer::get_assignees {
    case_id
    object_id
    role_id
} {
    return [db_string select_project_maintainer {} -default {}]
}
    
#####
#
# Notification Info
#
#####

ad_proc -private portal_content::content::notification_info::pretty_name {} {
    return "[_ portal-content.Bug-tracker_2]"
}

ad_proc -private portal_content::content::notification_info::get_notification_info {
    case_id
    object_id
} {
    portal_content::content::get -content_id $object_id -array content

    set url "[ad_url][apm_package_url_from_id $content(project_id)]content?[export_vars { { content_number $content(content_number) } }]"

    portal_content::get_pretty_names -array pretty_names

    set notification_subject_tag [db_string select_notification_tag {} -default {}]

    set one_line "$pretty_names(Bug) $content(summary)"

    # Build up data structures with the form labels and values
    # (Note, this is something that the metadata system should be able to do for us)

    array set label {
        summary "[_ portal-content.Summary]"
        status "[_ portal-content.Status]"
        found_in_version "[_ portal-content.Found]"
        fix_for_version "[_ portal-content.Fix]"
        fixed_in_version "[_ portal-content.Fixed_1]"
    }

    set label(content_number) "$pretty_names(Bug) "
    set label(component) "$pretty_names(Component)"

    set fields {
        content_number
        component
    }

    # keywords
    foreach { category_id category_name } [portal_content::category_types] {
        lappend fields $category_id
        set value($category_id) [portal_content::category_heading \
                                     -keyword_id [cr::keyword::item_get_assigned -item_id $content(content_id) -parent_id $category_id] \
                                     -package_id $content(project_id)]
        set label($category_id) $category_name
    }

    lappend fields summary status 

    if { [portal_content::versions_p -package_id $content(project_id)] } {
        lappend fields found_in_version fix_for_version fixed_in_version
    }

    set value(content_number) $content(content_number)
    set value(component)  $content(component_name)
    set value(summary) $content(summary)
    set value(status) $content(pretty_state)
    set value(found_in_version) [ad_decode $content(found_in_version_name) "" "[_ portal-content.Unknown]" $content(found_in_version_name)]
    set value(fix_for_version) [ad_decode $content(fix_for_version_name) "" "[_ portal-content.Undecided]" $content(fix_for_version_name)]
    set value(fixed_in_version) [ad_decode $content(fixed_in_version_name) "" "[_ portal-content.Unknown]" $content(fixed_in_version_name)]

    # Remove fields that should be hidden in this state
    foreach field $content(hide_fields) {
        set index [lsearch -exact $fields $field]
        if { $index != -1 } {
            set fields [lreplace $fields $index $index]
        }
    }
    
    # Build up the details list
    set details_list [list]
    foreach field $fields {
        lappend details_list $label($field) $value($field)
    }

    return [list $url $one_line $details_list $notification_subject_tag]
}
    

#####
# 
# Bug list
#
#####

ad_proc portal_content::content::get_list {
    {-ulevel 1}
} {
    set package_id [ad_conn package_id]
    set workflow_id [portal_content::content::get_instance_workflow_id]
    portal_content::get_pretty_names -array pretty_names

    set elements {
        content_number {
            label "[portal_content::conn Bug] [_ portal-content.number_symbol]"
            display_template {[_ portal-content.number_symbol]@contents.content_number@}
            html { align right }
        }
        summary {
            label "[_ portal-content.Summary]"
            link_url_eval {[export_vars -base content -entire_form -override { content_number }]}
            aggregate_label {[_ portal-content.Number]}
	}
	comment {
	    label "[_ portal-content.Details]"
            display_col comment_short
            hide_p 1
        }
        state {
            label "[_ portal-content.State]"
            display_template {@contents.pretty_state@<if @contents.resolution@ not nil> (@contents.resolution_pretty@)</if>}
            aggregate count
        }
        creation_date_pretty {
            label "[_ portal-content.Submitted]"
        }
        submitter {
            label "[_ portal-content.Submitter]"
            display_template {<a href="@contents.submitter_url@">@contents.submitter_first_names@ @contents.submitter_last_name@</a>}
        }
        assigned_to {
            label "Assigned To"
            display_template {<a href="@contents.assignee_url@">@contents.assignee_first_names@
                               @contents.assignee_last_name@</a>
                               <if @contents.action_pretty_name@ not nil> to </if>
                               @contents.action_pretty_name@}
        }
    }

    if { [portal_content::versions_p] } {
        lappend elements fix_for_version {
            label "[_ portal-content.Fix_1]"
            display_col fix_for_version_name
        }
    }
    
    lappend elements component {
        label "[_ portal-content.Component]"
        display_col component_name
    }

    set state_values [portal_content::state_get_filter_data \
                         -package_id $package_id \
                         -workflow_id $workflow_id]
    set state_default_value [lindex [lindex $state_values 0] 1]

    set filters {
        project_id {}
        f_state {
            label "[_ portal-content.State]"
            values $state_values
            where_clause {cfsm.current_state = :f_state}
            default_value $state_default_value
        }
    }

    set orderbys {
        default_value content_number,desc
        content_number {
            label "[portal_content::conn Bug] \#"
            orderby content_number
            default_direction desc
        }
        summary {
            label "[_ portal-content.Summary]"
            orderby_asc {lower_summary asc, summary asc, content_number asc}
            orderby_desc {lower_summary desc, summary desc, content_number desc}
        }
        submitter {
            label "[_ portal-content.Submitter]"
            orderby_asc {lower_submitter_first_names asc, lower_submitter_last_name asc, content_number asc}
            orderby_desc {lower_submitter_first_names desc, lower_submitter_last_name desc, content_number desc}
        }
    }

    set category_defaults [list]


    foreach { parent_id parent_heading } [portal_content::category_types] {
        lappend elements category_$parent_id [list label [portal_content::category_heading -keyword_id $parent_id] display_col category_name_$parent_id]

        set values [portal_content::category_get_filter_data \
                       -package_id $package_id \
                       -parent_id $parent_id]

        set name category_$parent_id
        
        set where_clause [db_map category_where_clause]

        lappend filters f_$name \
            [list \
                 label $parent_heading \
                 values $values \
                 where_clause $where_clause]

        lappend orderbys $name \
            [list \
                 label $parent_heading \
                 orderby_desc {heading desc, content_number desc} \
                 orderby_asc {heading asc, content_number asc}]
    }

    if { [portal_content::versions_p] } {
        lappend filters f_fix_for_version {
            label "[_ portal-content.Fix]"
            values {[portal_content::version_get_filter_data -package_id $package_id]}
            where_clause { b.fix_for_version = :f_fix_for_version }
            null_where_clause { b.fix_for_version is null }
            null_label "[_ portal-content.Undecided]"
        }
    }

    foreach action_id [workflow::get_actions -workflow_id $workflow_id] {
        array unset action
        workflow::action::get -action_id $action_id -array action

        set values [portal_content::assignee_get_filter_data \
                       -package_id $package_id \
                       -workflow_id $workflow_id \
                       -action_id $action_id]
        
        lappend filters f_action_$action_id \
            [list \
                 label $action(pretty_name) \
                 values $values \
                 null_label "[_ portal-content.Unassigned]" \
                 where_clause [db_map filter_assignee_where_clause] \
                 null_where_clause [db_map filter_assignee_null_where_clause]]
    }

    # Stat: By Component

    lappend filters f_component {
        label "[_ portal-content.Component]"
        values {[portal_content::component_get_filter_data -package_id $package_id]}
        where_clause {b.component_id = :f_component}
    }

    upvar \#[template::adp_level] format format
    
    foreach var [portal_content::get_export_variables] { 
        upvar \#[template::adp_level] $var $var
    }

    template::list::create \
        -ulevel [expr $ulevel + 1] \
        -name contents \
        -multirow contents \
        -class "list-tiny" \
        -sub_class "narrow" \
        -pass_properties { pretty_names } \
        -elements $elements \
        -filters $filters \
        -orderby $orderbys \
        -page_size 25 \
        -page_flush_p 0 \
        -page_query {[portal_content::content::get_query -query_name contents_pagination]} \
        -formats {
            table {
                label "[_ portal-content.Table]"
                layout table
            }
            list {
                label "[_ portal-content.List]"
                layout list
                template {
                    <p class="bt">
                      <span style="font-size: 115%;">
                        <listelement name="content_number"><span class="bt_douce">. </span>
                        <listelement name="summary"><br>
                      </span>
                      <listelement name="comment"><br>
                      <span class="bt_douce">@pretty_names.Component@:</span> <listelement name="component">
                      <span class="bt_douce">- Opened</span> <listelement name="creation_date_pretty">
                      <span class="bt_douce">By</span> <listelement name="submitter"><br>
                      <span class="bt_douce">Status:</span>
                      <span style="color: #008000;"><b><listelement name="state"></b>
                    </p>
                }
            }
        } \
        -selected_format $format
}

ad_proc portal_content::content::get_query {
    {-query_name contents}
} {
    @param name Either "contents" or "contents_pagination"
    @return The query
} {

    upvar \#[template::adp_level] orderby orderby 

    # Needed to handle ordering by categories
    set from_content_clause "bt_contents b"
    set orderby_category_where_clause {}

    # Lars: This is a little hack because we actually need to alter the query to sort by category
    # but list builder currently doesn't support that.

    if { [info exists orderby] && [regexp {^category_(.*),.*$} $orderby match orderby_parent_id] } {
        append from_content_clause [db_map orderby_category_from_content_clause]
        set orderby_category_where_clause [db_map orderby_category_where_clause]

        # Branimir: The ORDER BY clause needs to be at the very end of the
        # query. That also means that we need to have in the select list every
        # column we want to order by.  Which colums we can afford to have in
        # the select list depends on which tables are we joining against.  BTW,
        # all these kludges are consequence of the initial (bad, IMHO) decision
        # to do the joins against cr_keywords in memory rather then in SQL.
        set more_columns ", kw_order.heading as heading"
    } else {
        set more_columns ""
    }

    return [db_map $query_name]
}


ad_proc portal_content::content::get_multirow {} {
    foreach var [portal_content::get_export_variables] { 
#JOEL put this back later
        upvar \#[template::adp_level] $var $var
    }

    set workflow_id [portal_content::content::get_instance_workflow_id]
    set truncate_len [parameter::get -parameter "TruncateDescriptionLength" -default 200]

    set extend_list { 
        comment_short
        submitter_url 
        assignee_url 
        status_pretty
        resolution_pretty
        component_name
        found_in_version_name
        fix_for_version_name
        fixed_in_version_name
    }

    set category_defaults [list]

    foreach { parent_id parent_heading } [portal_content::category_types] {
        lappend category_defaults $parent_id {}
        lappend extend_list "category_$parent_id" "category_name_$parent_id"
    }

    array set row_category $category_defaults
    array set row_category_names $category_defaults
    db_multirow -extend $extend_list contents select_contents [get_query] {

        # parent_id is part of the column name
        set parent_id [portal_content::category_parent_element -keyword_id $keyword_id -element id]

        # Set the keyword_id and heading for the category with this parent
        set row_category($parent_id) $keyword_id
        set row_category_name($parent_id) [portal_content::category_heading -keyword_id $keyword_id]

        if { [db_multirow_group_last_row_p -column content_id] } {
            set component_name [portal_content::component_get_name -component_id $component_id]
            set found_in_version_name [portal_content::version_get_name -version_id $found_in_version]
            set fix_for_version_name [portal_content::version_get_name -version_id $fix_for_version]
            set fixed_in_version_name [portal_content::version_get_name -version_id $fixed_in_version]
            set comment_short [string_truncate -len $truncate_len -- $comment_content]
            set submitter_url [acs_community_member_url -user_id $submitter_user_id]
            set assignee_url [acs_community_member_url -user_id $assigned_user_id]
            set resolution_pretty [portal_content::resolution_pretty $resolution]
            
            # Hide fields in this state
            foreach element $hide_fields {
                set $element {}
            }
            
            # Move categories from array to normal variables, then clear the array for next row
            foreach parent_id [array names row_category] {
                set category_$parent_id $row_category($parent_id)
                if {[info exists row_category_name($parent_id)]} { 
                    set category_name_$parent_id $row_category_name($parent_id)
                } else { 
                    set category_name_$parent_id {}
                }
            }


            unset row_category
            unset row_category_name
            array set row_category $category_defaults
            array set row_category_name $category_defaults
        } else {
            continue
        }
    }

}

ad_proc portal_content::content::get_content_numbers {} {
    portal_content::content::get_list -ulevel 2
    portal_content::content::get_multirow
    
    set filter_content_numbers [list]
    template::multirow foreach contents {
        lappend filter_content_numbers $content_number
    }

    return $filter_content_numbers
}
