ad_library {

    Portal Content Install library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date 2003-01-31
    @author Lars Pind <lars@collaboraid.biz>
    @cvs-id $Id: install-procs.tcl,v 1.4 2005/01/13 13:56:16 jeffd Exp $
}


namespace eval portal_content::install {}

ad_proc -private portal_content::install::package_install {} {
    Package installation callback proc
} {
    db_transaction {
        portal_content::install::register_implementations
        portal_content::search::register_implementations
        portal_content::content::workflow_create
    }
}

ad_proc -private portal_content::install::package_uninstall {} {
    Package un-installation callback proc
} {
    db_transaction {
        portal_content::content::workflow_delete
        portal_content::install::unregister_implementations
        portal_content::search::unregister_implementations
    }
}

ad_proc -private portal_content::install::package_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    Package before-upgrade callback
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            0.9d1 1.2d2 {
                # This is the upgrade that converts Portal Content to using the workflow package
                ns_log Notice "portal_content::install::package_upgrade - Upgrading Portal Content from 09d1 to 1.2d2"

                # This sets up the the but tracker package type workflow instance
                package_install

                # Create a workflow instance for each Portal Content project
                db_foreach select_project_ids {} {
                    portal_content::content::instance_workflow_create -package_id $project_id
                }
            }
            1.4d2 1.4d3 { 
                portal_content::search::register_implementations
            }
            1.3a6 1.3a7 {
                ns_log Notice "portal_content::install::package_upgrade - Upgrading Portal Content from 1.3a6 to 1.3a7"
                # Previous upgrades added workflow and workflow cases but not enabled actions
                # for each workflow case.  Bug.
                db_foreach select_case_ids {} {
                    workflow::case::state_changed_handler -case_id $case_id
                }
            }
        }
}

ad_proc -private portal_content::install::package_instantiate {
    {-package_id:required}
} {
    Package instantiation callback proc
} {
    # Create the project
    portal_content::project_new $package_id

    portal_content::content::instance_workflow_create -package_id $package_id
}

ad_proc -private portal_content::install::package_uninstantiate {
    {-package_id:required}
} {
    Package un-instantiation callback proc
} {

    portal_content::project_delete $package_id
    portal_content::content::instance_workflow_delete -package_id $package_id

}

#####
#
# Service contract implementations
#
#####

ad_proc -private portal_content::install::register_implementations {} {
    db_transaction {
        portal_content::install::register_capture_resolution_code_impl
        portal_content::install::register_project_maintainer_impl
        portal_content::install::register_component_maintainer_impl
        portal_content::install::register_format_log_title_impl
        portal_content::install::register_content_notification_info_impl
    }
}

ad_proc -private portal_content::install::unregister_implementations {} {
    db_transaction {

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::action_side_effect] \
                -impl_name "CaptureResolutionCode"

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::activity_log_format_title] \
                -impl_name "FormatLogTitle"

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::role_default_assignees]  \
                -impl_name "ComponentMaintainer"

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::role_default_assignees] \
                -impl_name "ProjectMaintainer"

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::notification_info] \
                -impl_name "BugNotificationInfo"
    }
}

ad_proc -private portal_content::install::register_capture_resolution_code_impl {} {

    set spec {
        name "CaptureResolutionCode"
        aliases {
            GetObjectType portal_content::content::object_type
            GetPrettyName portal_content::content::capture_resolution_code::pretty_name
            DoSideEffect  portal_content::content::capture_resolution_code::do_side_effect
        }
    }
    
    lappend spec contract_name [workflow::service_contract::action_side_effect] 
    lappend spec owner [portal_content::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private portal_content::install::register_component_maintainer_impl {} {

    set spec {
        name "ComponentMaintainer"
        aliases {
            GetObjectType portal_content::content::object_type
            GetPrettyName portal_content::content::get_component_maintainer::pretty_name
            GetAssignees  portal_content::content::get_component_maintainer::get_assignees
        }
    }
    
    lappend spec contract_name [workflow::service_contract::role_default_assignees]
    lappend spec owner [portal_content::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private portal_content::install::register_project_maintainer_impl {} {

    set spec {
        name "ProjectMaintainer"
        aliases {
            GetObjectType portal_content::content::object_type
            GetPrettyName portal_content::content::get_project_maintainer::pretty_name
            GetAssignees  portal_content::content::get_project_maintainer::get_assignees
        }
    }
    
    lappend spec contract_name [workflow::service_contract::role_default_assignees]
    lappend spec owner [portal_content::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}
        
ad_proc -private portal_content::install::register_format_log_title_impl {} {

    set spec {
        name "FormatLogTitle"
        aliases {
            GetObjectType portal_content::content::object_type
            GetPrettyName portal_content::content::format_log_title::pretty_name
            GetTitle      portal_content::content::format_log_title::format_log_title
        }
    }
    
    lappend spec contract_name [workflow::service_contract::activity_log_format_title]
    lappend spec owner [portal_content::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private portal_content::install::register_content_notification_info_impl {} {

    set spec {
        name "BugNotificationInfo"
        aliases {
            GetObjectType       portal_content::content::object_type
            GetPrettyName       portal_content::content::notification_info::pretty_name
            GetNotificationInfo portal_content::content::notification_info::get_notification_info
        }
    }
    
    lappend spec contract_name [workflow::service_contract::notification_info]
    lappend spec owner [portal_content::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}

