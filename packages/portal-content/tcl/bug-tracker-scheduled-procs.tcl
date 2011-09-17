# /packages/portal-content/tcl/portal-content-scheduled-procs.tcl

ad_library {
    
    
    
    @author Victor Guerra (guerra@galileo.edu)
    @creation-date 2005-02-07
    @arch-tag: bfe519e0-3005-46c5-835f-fa7c59938ddd
    @cvs-id $Id: portal-content-scheduled-procs.tcl,v 1.1 2005/02/25 17:08:11 victorg Exp $
}

namespace eval content_tacker {}
namespace eval portal_content::scheduled {}

ad_proc -public portal_content::scheduled::close_contents {
} {
} {
    set bt_instance [parameter::get -parameter BugTrackerInstance -package_id [ad_acs_kernel_id] -default {}]
    if {![empty_string_p $bt_instance]} {
	array set community_info [site_node::get -url "${bt_instance}/[portal_content::package_key]"]
	set bt_package_id $community_info(package_id)
	db_foreach open_content { *SQL* } {
	    set case_id [workflow::case::get_id \
			     -object_id $content_id \
			     -workflow_short_name [portal_content::content::workflow_short_name]]
	    workflow::case::fsm::get -case_id $case_id -array case
	    set time_to_compare_with [parameter::get -parameter TimeToLive -package_id $bt_package_id -default 0]
	    if { [string eq $case(state_short_name) "open"] && $time_to_compare_with > 0 && [db_string too_old {} -default 0] } {
		foreach available_enabled_action_id [workflow::case::get_available_enabled_action_ids -case_id $case_id] {
		    workflow::case::enabled_action_get -enabled_action_id $available_enabled_action_id -array enabled_action
		    workflow::action::get -action_id $enabled_action(action_id) -array available_action
		    if { [string eq $available_action(short_name) "resolve"] } {
			set action_id $enabled_action(action_id)
			array set row [list]
			foreach field [workflow::action::get_element -action_id $action_id -element edit_fields] {
			    set row($field) ""
			}
			foreach {category_id category_name} [portal_content::category_types] {
			    set row($category_id) ""
			}
			portal_content::content::edit \
			    -content_id $content_id \
			    -enabled_action_id $available_enabled_action_id \
			    -description descripcion \
			    -desc_format text/html \
			    -array row
		    }
		}
		foreach available_enabled_action_id [workflow::case::get_available_enabled_action_ids -case_id $case_id] {
		    workflow::case::enabled_action_get -enabled_action_id $available_enabled_action_id -array enabled_action
		    workflow::action::get -action_id $enabled_action(action_id) -array available_action
		    if { [string eq $available_action(short_name) "close"] } {
			set action_id $enabled_action(action_id)
			array set row [list]
			foreach field [workflow::action::get_element -action_id $action_id -element edit_fields] {
			    set row($field) ""
			}
			foreach {category_id category_name} [portal_content::category_types] {
			    set row($category_id) ""
			}
			
			portal_content::content::edit \
			    -content_id $content_id \
			    -enabled_action_id $available_enabled_action_id \
			    -description descripcion \
			    -desc_format text/html \
			    -array row
		    }
		}
	    }
	}
    }
}
