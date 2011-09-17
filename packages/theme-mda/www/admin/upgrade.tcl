set package_id [site_node::get_element -url /dotlrn -element package_id]
db_transaction {

    parameter::set_from_package_key \
        -package_key new-portal \
        -parameter default_theme_name \
        -value "#theme-zen.Zen_Theme#"

    parameter::set_from_package_key \
        -package_key acs-subsite \
        -parameter DefaultMaster \
        -value /packages/theme-zen/lib/lrn-master

    parameter::set_default \
        -package_key dotlrn \
        -parameter class_instance_pages_csv \
        -value "#dotlrn.class_page_home_title#,#theme-zen.Zen_thin_thick#,#dotlrn.class_page_home_accesskey#;#dotlrn.class_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.class_page_calendar_accesskey#;#dotlrn.class_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.class_page_file_storage_accesskey#"

    parameter::set_default \
        -package_key dotlrn \
        -parameter club_pages_csv \
        -value "#dotlrn.club_page_home_title#,#theme-zen.Zen_thin_thick#,#dotlrn.club_page_home_accesskey#;#dotlrn.club_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.club_page_calendar_accesskey#;#dotlrn.club_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.club_page_file_storage_accesskey#;#dotlrn.club_page_people_title#,#theme-zen.Zen_1_column#,#dotlrn.club_page_people_accesskey#"

    parameter::set_default \
        -package_key dotlrn \
        -parameter subcomm_pages_csv \
        -value "#dotlrn.subcomm_page_home_title,#theme-zen.Zen_thin_thick#,#dotlrn.subcomm_page_home_accesskey#;#dotlrn.subcomm_page_info_title#,#theme-zen.Zen_1_column#,#dotlrn.subcomm_page_info_accesskey#;#dotlrn.subcomm_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.subcomm_page_calendar_accesskey#;#dotlrn.subcomm_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.subcomm_page_file_storage_accesskey#"

    parameter::set_default \
        -package_key dotlrn \
        -parameter user_portal_pages_csv \
        -value "#dotlrn.user_portal_page_home_title#,#theme-zen.Zen_thin_thick#,#dotlrn.user_portal_page_home_accesskey#;#dotlrn.user_portal_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.user_portal_page_calendar_accesskey#;#dotlrn.user_portal_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.user_portal_page_file_storage_accesskey#"

    parameter::set_default \
        -package_key dotlrn \
        -parameter DefaultSiteTemplate \
        -value "#theme-zen.Zen_Theme#"

    parameter::set_default \
        -package_key dotlrn \
        -parameter DefaultMaster_p \
        -value "/packages/theme-zen/lib/lrn-master"

    parameter::set_default \
        -package_key dotlrn \
        -parameter non_member_layout_name \
        -value "#theme-zen.Zen_2_column#"

    parameter::set_default \
        -package_key dotlrn \
        -parameter admin_layout_name \
        -value "#theme-zen.Zen_2_column#"

    # Poached from dotlrn's package instantiate callback.

    set site_template_id [db_string select_st_id {}]
           
    # for communities
    parameter::set_value -package_id $package_id \
        -parameter  "CommDefaultSiteTemplate_p" \
        -value $site_template_id
    	   
    # for users
    parameter::set_value -package_id $package_id \
        -parameter  "UserDefaultSiteTemplate_p" \
        -value $site_template_id

    db_1row get_theme {}
    db_dml update_theme {}

    foreach {old new} [parameter::get -package_id [ad_conn package_id] -parameter dotLRNToZenMap] {
        db_1row get_old {}
        db_1row get_new {}
        db_dml update_layouts {}
    }

}

ad_return_template
