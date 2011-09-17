ad_page_contract {
    Shows one content.

    @author Lars Pind (lars@pinds.com)
    @creation-date 2002-03-20
    @cvs-id $Id: content.tcl,v 1.38 2005/03/01 00:01:26 jeffd Exp $
} [portal_content::get_page_variables {
    content_number:integer,notnull
    {user_agent_p:boolean 0}
    {show_patch_status open}
}]

#####
#
# Setup
#
#####

ns_log Notice "********************************************************"

set return_url [export_vars -base [ad_conn url] [portal_content::get_export_variables { content_number }]]

set project_name [portal_content::conn project_name]
set package_id [ad_conn package_id]
set package_key [ad_conn package_key]

set user_id [ad_conn user_id]

permission::require_permission -object_id $package_id -privilege read

set content_name [portal_content::conn Bug]
set page_title [_ portal-content.Bug_Title]

set context [list [ad_quotehtml $page_title]]

# Is this project using multiple versions?
set versions_p [portal_content::versions_p]

# Paches enabled for this project?
set patches_p [portal_content::patches_p]


#####
#
# Get basic info
#
#####

# Get the content_id
if { ![db_0or1row permission_info {} -column_array content] } {
    ad_return_complaint 1 [_ portal-content.Bug_not_found]
    ad_script_abort
}

set case_id [workflow::case::get_id \
        -object_id $content(content_id) \
        -workflow_short_name [portal_content::content::workflow_short_name]]

set workflow_id [portal_content::content::get_instance_workflow_id ]


#####
#
# Action
#
#####

set enabled_action_id [form get_action content]


# Registration required for all actions
set action_id ""
if { ![empty_string_p $enabled_action_id] } {
    ns_log Notice "enabled_action if statement"
    auth::require_login
    workflow::case::enabled_action_get -enabled_action_id $enabled_action_id -array enabled_action    
    set action_id $enabled_action(action_id)
}


# Check permissions
if { ![workflow::case::action::available_p -enabled_action_id $enabled_action_id] } {
    portal_content::security_violation -user_id $user_id -content_id $content(content_id) -action_id $action_id
}


ns_log Notice "actions: enabled_action_id: -${enabled_action_id}-"


# Buttons
set actions [list]
if { [empty_string_p $enabled_action_id] } {

    ns_log Notice "actions: case_id: $case_id"
    ns_log Notice "actions: case_id: $case_id get_enabled_actions: [workflow::case::get_available_enabled_action_ids -case_id $case_id]"

    foreach available_enabled_action_id [workflow::case::get_available_enabled_action_ids -case_id $case_id] {
        # TODO: avoid the enabled_action_get query by caching it, or caching only the enabled_action_id -> action_id lookup?
        workflow::case::enabled_action_get -enabled_action_id $available_enabled_action_id -array enabled_action
        workflow::action::get -action_id $enabled_action(action_id) -array available_action
        lappend actions [list "     [lang::util::localize $available_action(pretty_name)]     " $available_enabled_action_id]
    }
}

#####
#
# Create the form
#
#####

# Set the variable that we need for the elements below


# set patch label
# JCD: The string map below is to work around a "feature" in the form generation that 
# lets you use +var+ for a var to eval on the second round.  
# cf http://openacs.org/contenttracker/openacs/content?content%5fnumber=1099

if { [empty_string_p $enabled_action_id] } {
    set patch_label [ad_decode $show_patch_status \
                         "open" "[_ portal-content.Open] [portal_content::conn Patches] (<a href=\"[string map {+ %20} [export_vars -base [ad_conn url] -entire_form -override { { show_patch_status all } }]]\">[_ portal-content.show_all]</a>)" \
                         "all" "[_ portal-content.All] [portal_content::conn Patches] (<a href=\"[string map {+ %20} [export_vars -base [ad_conn url] -entire_form -override { { show_patch_status open } }]]\">[_ portal-content.show_only_open])" \
                         "[portal_content::conn Patches]"]
} else {
    set patch_label [ad_decode $show_patch_status \
                         "open" "[_ portal-content.Open] [portal_content::conn Patches]" \
                         "all" "[_ portal-content.All] [portal_content::conn Patches]" \
                         "[portal_content::conn Patches]"]
}

ad_form -name content -cancel_url $return_url -mode display -has_edit 1 -actions $actions -form  {
    {content_number_display:text(inform)
	{label "[portal_content::conn Bug] \#"}
        {mode display}
    }
    {component_id:integer(select),optional
	{label "[portal_content::conn Component]"}
	{options {[portal_content::components_get_options]}}
	{mode display}
    }
    {summary:text(text)
	{label "[_ portal-content.Summary]"}
	{before_html "<b>"}
	{after_html "</b>"}
	{mode display}
	{html {size 50}}
    }
}


ad_form -extend -name content -form {
    {pretty_state:text(inform)
	{label "[_ portal-content.Status]"}
	{before_html "<b>"}
	{after_html  "</b>"}
	{mode display}
    }
    {resolution:text(select),optional
	{label "[_ portal-content.Resolution]"}
	{options {[portal_content::resolution_get_options]}}
	{mode display}
    }
}

foreach {category_id category_name} [portal_content::category_types] {
    ad_form -extend -name content -form [list \
        [list "${category_id}:integer(select)" \
            [list label $category_name] \
            [list options [portal_content::category_get_options -parent_id $category_id]] \
            [list mode display] \
        ] \
    ]
}


ad_form -extend -name content -form {
    {found_in_version:text(select),optional
	{label "[_ portal-content.Found_in_Version]"}
	{options {[portal_content::version_get_options -include_unknown]}}
	{mode display}
    }
}

workflow::case::role::add_assignee_widgets -case_id $case_id -form_name content

# More fixed form elements

ad_form -extend -name content -form {
    {patches:text(inform)
	{label $patch_label}
	{mode display}
    }
    {user_agent:text(inform)
	{label "[_ portal-content.User_Agent]"}
	{mode display}
    }
    {fix_for_version:text(select),optional
	{label "[_ portal-content.Fix_for_Version]"}
	{options {[portal_content::version_get_options -include_undecided]}}
	{mode display}
    }
    {fixed_in_version:text(select),optional
	{label "[_ portal-content.Fixed_in_Version]"}
	{options {[portal_content::version_get_options -include_undecided]}}
	{mode display}
    }
    {description:richtext(richtext),optional
	{label "[_ portal-content.Description]"} 
	{html {cols 60 rows 13}} 
    }
    {return_url:text(hidden) 
	{value $return_url}
    }
    {content_number:key}
    {entry_id:integer(hidden),optional}
}

# TODO: Export filters
set filters [list]
foreach name [portal_content::get_export_variables] { 
    if { [info exists $name] } {
        lappend filters [list "${name}:text(hidden),optional" [list value [set $name]]]
    }
}
ad_form -extend -name content -form $filters

# Set editable fields
if { ![empty_string_p $enabled_action_id] } {   
    foreach field [workflow::action::get_element -action_id $action_id -element edit_fields] { 
	element set_properties content $field -mode edit 
    }
    
    # LARS: Hack! How do we set editing of dynamic fields?
    if { [string equal [workflow::action::get_element -action_id $action_id -element short_name] edit] } {
        foreach { category_id category_name } [portal_content::category_types] {
            element set_properties content $category_id -mode edit
        }
    }
} 
    

# on_submit block
ad_form -extend -name content -on_submit {

    array set row [list] 
    
    if { ![empty_string_p $enabled_action_id] } { 
        foreach field [workflow::action::get_element -action_id $action_id -element edit_fields] {
            set row($field) [element get_value content $field]
        }
        foreach {category_id category_name} [portal_content::category_types] {
            set row($category_id) [element get_value content $category_id]
        }
    }
    
    set description [element get_value content description]
    
    portal_content::content::edit \
            -content_id $content(content_id) \
            -enabled_action_id $enabled_action_id \
            -description [template::util::richtext::get_property contents $description] \
            -desc_format [template::util::richtext::get_property format $description] \
            -array row \
            -entry_id [element get_value content entry_id]    


    ad_returnredirect $return_url
    ad_script_abort

} -edit_request {
    # Dummy
    # If we don't have this, ad_form complains
}

# Not-valid block (request or submit error)
# Unfortunately, ad_form doesn't let us do what we want, namely have a block that executes
# whenever the form is displayed, whether initially or because of a validation error.
if { ![form is_valid content] } {

    # Get the content data
    portal_content::content::get -content_id $content(content_id) -array content -enabled_action_id $enabled_action_id


    # Make list of form fields
    set element_names {
        content_number component_id summary pretty_state resolution 
        found_in_version user_agent fix_for_version fixed_in_version 
        content_number_display entry_id
    }

    # update the element_name list and content array with category stuff
    foreach {category_id category_name} [portal_content::category_types] {
        lappend element_names $category_id
        set content($category_id) [cr::keyword::item_get_assigned -item_id $content(content_id) -parent_id $category_id]
        if {[string compare $content($category_id) ""] == 0} {
            set content($category_id) [portal_content::get_default_keyword -parent_id $category_id]
        }
    }
    
    # Display value for patches
    set content(patches_display) "[portal_content::get_patch_links -content_id $content(content_id) -show_patch_status $show_patch_status] &nbsp; \[ <a href=\"patch-add?[export_vars { { content_number $content(content_number) } { component_id $content(component_id) } }]\">[_ portal-content.Upload_Patch]</a> \]"

    # Hide elements that should be hidden depending on the content status
    foreach element $content(hide_fields) {
        element set_properties content $element -widget hidden
    }

    if { !$versions_p } {
        foreach element { found_in_version fix_for_version fixed_in_version } {
            if { [info exists content:$element] } {
                element set_properties content $element -widget hidden
            }
        }
    }

    if { !$patches_p } {
        foreach element { patches } {
            if { [info exists content:$element] } {
                element set_properties content $element -widget hidden
            }
        }
    }

    # Optionally hide user agent
    if { !$user_agent_p } {
        element set_properties content user_agent -widget hidden
    }

    # Set regular element values
    foreach element $element_names { 

        # check that the element exists
        if { [info exists content:$element] && [info exists content($element)] } {
            if {[form is_request content] 
                || [string equal [element get_property content $element mode] display] } { 
                if { [string first "#" $content($element)] == 0 } {
                    element set_value content $element [lang::util::localize $content($element)]
                } else {
                    element set_value content $element $content($element)
                }
            }
        }
    }
    
    # Add empty option to resolution code
    if { ![empty_string_p $enabled_action_id] } {
        if { [lsearch [workflow::action::get_element -action_id $action_id -element edit_fields] "resolution"] == -1 } {
            element set_properties content resolution -options [concat {{{} {}}} [element get_property content resolution options]]
        }
    } else {
        element set_properties content resolution -widget hidden
    }

    # Get values for the role assignment widgets
    workflow::case::role::set_assignee_values -case_id $case_id -form_name content
    
    # Set values for elements with separate display value
    foreach element { 
        patches
    } {
        # check that the element exists
        if { [info exists content:$element] } {
            element set_properties content $element -display_value $content(${element}_display)
        }
    }

    # Set values for description field
    element set_properties content description \
            -before_html [workflow::case::get_activity_html -case_id $case_id -action_id $action_id]

    # Set page title
    set page_title "[portal_content::conn Bug] #$content_number: $content(summary)"

    # Context bar
    # TODO: Make real
    set filtered_p 1
    if { $filtered_p } {
        set content_name [portal_content::conn content]
        set context [list \
                         [list \
                              [export_vars -base . [portal_content::get_export_variables]] \
                              [_ portal-content.Filtered]] \
                         [ad_quotehtml $page_title]]
    } else {
        set context [list [ad_quotehtml $page_title]]
    }
    
    # User agent show/hide URLs
    if { [empty_string_p $enabled_action_id] } {
        set show_user_agent_url [export_vars -base content -entire_form -override { { user_agent_p 1 }}]
        set hide_user_agent_url [export_vars -base content -entire_form -exclude { user_agent_p }]
    }
    
    # Login
    set login_url [ad_get_login_url]
    
    # Single-content notifications 
    if { [empty_string_p $enabled_action_id]  } {
        set notification_link [portal_content::content::get_watch_link -content_id $content(content_id)]
    }


    # Filter management
    if { [empty_string_p $enabled_action_id] } {
    
        set filter_content_numbers [portal_content::content::get_content_numbers]
        set filter_content_index [lsearch -exact $filter_content_numbers $content_number]

        set first_url {}
        set last_url {}
        set prev_url {}
        set next_url {}
        
        if { $filter_content_index == -1 } {
            # This content is not included in the list, get the client property (if it exists)
            set filter_content_numbers [ad_get_client_property portal-content filter_content_numbers]
        } else {
            # This content is included in the list
            ad_set_client_property portal-content filter_content_numbers $filter_content_numbers 
        }

        set filter_content_index [lsearch -exact $filter_content_numbers $content_number]

        if { $filter_content_index > 0 } {
            set first_content_number [lindex $filter_content_numbers 0]
            set first_url [export_vars -base content -entire_form -override { { content_number $first_content_number } }]
            set prev_content_number [lindex $filter_content_numbers [expr $filter_content_index -1]]
            set prev_url [export_vars -base content -entire_form -override { { content_number $prev_content_number } }]
        }
        if { $filter_content_index < [expr [llength $filter_content_numbers]-1] } {
            set next_content_number [lindex $filter_content_numbers [expr $filter_content_index +1]]
            set next_url [export_vars -base content -entire_form -override { { content_number $next_content_number } }]
            set last_content_number [lindex $filter_content_numbers end]
            set last_url [export_vars -base content -entire_form -override { { content_number $last_content_number } }]
        }

        multirow create navlinks url img alt label

        if { $filter_content_index != -1 } {

            set next_content_num [expr $filter_content_index+1]
            set all_contents [llength $filter_content_numbers]
            multirow append navlinks \
                $first_url \
                "/resources/acs-subsite/stock_first-16.png" \
                [_ acs-kernel.common_first]

            multirow append navlinks \
                $prev_url \
                "/resources/acs-subsite/stock_left-16.png" \
                [_ acs-kernel.common_previous]

            multirow append navlinks \
                {} \
                {} \
                {} \
                [_ portal-content.No_of_All]

            multirow append navlinks \
                $next_url \
                "/resources/acs-subsite/stock_right-16.png" \
                [_ acs-kernel.common_next]

            multirow append navlinks \
                $last_url \
                "/resources/acs-subsite/stock_last-16.png" \
                [_ acs-kernel.common_last]
        }
    }
}
