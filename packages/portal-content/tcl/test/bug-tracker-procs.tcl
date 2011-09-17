ad_library {
    Automated tests.

    @author Don Baccus
    @cvs-id $Id: portal-content-procs.tcl,v 1.2 2005/01/13 13:56:17 jeffd Exp $
}

aa_register_case -cats {api smoke} project_new {
    Test our ability to generate a new project and some contents.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {
            if { [catch {array set site_node [site_node::get -url /portal-content]} errmsg] } {
                aa_error "Can't find portal-content at /portal-content: $errmsg"
            } else {

                # Don't believe the portal-content Tcl API that misleads you into
                # thinking that you can explicitly pass package_id as a parameter to
                # various procs.  The vile portal_content::conn proc guarantees this
                # does not work.
                set old_package_id [ad_conn package_id]
                ad_conn -set package_id $site_node(package_id)
                set package_id [ad_conn package_id]
                set user_id [ad_conn user_id]

                array set default_configs [portal_content::get_default_configurations]
                if { ![info exists default_configs(Bug-Tracker)] } {
                    aa_error "Can't find default portal-content configuration"
                } else {
                    array set config $default_configs(Bug-Tracker)
                    portal_content::delete_all_project_keywords 
                    portal_content::install_keywords_setup -spec $config(categories)
                    portal_content::install_parameters_setup -spec $config(parameters)
                    aa_equals "Bug tracker project creation test" [db_string count_projects {}] 1
                }

                # Create a dummy component
                portal_content::components_flush
                db_1row new_component_id {}
                db_dml new_component {}

                db_1row new_content_id {}
                portal_content::content::new \
                    -content_id $content_id \
                    -package_id $package_id \
	            -component_id $component_id \
	            -found_in_version [portal_content::conn user_version_id] \
	            -summary summary \
	            -description description \
	            -desc_format text/html \
                    -keyword_ids {}
                aa_log_result pass "Successfully created a content"

                ad_conn -set package_id $old_package_id
            }
        }
}
