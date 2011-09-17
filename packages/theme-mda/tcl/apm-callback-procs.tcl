ad_library {

     Theme MDA Package APM callbacks library

     Procedures that deal with installing.

     @creation-date May 2009
     @author  Alessandro Landim (alessandro.landim@gmail.com)

}

namespace eval theme_mda {}
namespace eval theme_mda::apm {}

ad_proc -public theme_mda::apm::after_install {} {

    Create the MDA Theme for the new-portals.

    Done here as a Tcl callback because ...

    1. It's simpler than writing SQL
    2. It works for both Oracle and PostgreSQL

} {

    set var_list [list \
        [list name "#theme-mda.MDA_1_column#"] \
        [list description "#theme-mda.MDA_1_column#"] \
        [list resource_dir /resources/theme-mda/css/mda1] \
        [list filename ../../theme-mda/lib/layouts/mda1]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list name "#theme-mda.MDA_2_column#"] \
        [list description "#theme-mda.MDA_2_column#"] \
        [list resource_dir /resources/theme-mda/css/mda2] \
        [list filename ../../theme-mda/lib/layouts/mda2]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list name "#theme-mda.MDA_3_column#"] \
        [list description "#theme-mda.MDA_3_column#"] \
        [list resource_dir /resources/theme-mda/css/mda3] \
        [list filename ../../theme-mda/lib/layouts/mda3]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list name "#theme-mda.MDA_4_column#"] \
        [list description "#theme-mda.MDA_4_column#"] \
        [list resource_dir /resources/theme-mda/css/mda4] \
        [list filename ../../theme-mda/lib/layouts/mda4]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 4]
    ]
 
    package_exec_plsql -var_list $var_list portal_layout add_region

	set var_list [list \
        [list name "#theme-mda.MDA_5_column#"] \
        [list description "#theme-mda.MDA_5_column#"] \
        [list resource_dir /resources/theme-mda/css/mda5] \
        [list filename ../../theme-mda/lib/layouts/mda5]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 4]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 5]
    ]
 
    package_exec_plsql -var_list $var_list portal_layout add_region

	set var_list [list \
        [list name "#theme-mda.MDA_6_column#"] \
        [list description "#theme-mda.MDA_6_column#"] \
        [list resource_dir /resources/theme-mda/css/mda6] \
        [list filename ../../theme-mda/lib/layouts/mda6]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 4]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 5]
    ]
 
    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list layout_id $layout_id] \
        [list region 6]
    ]
 
    package_exec_plsql -var_list $var_list portal_layout add_region



 
    set var_list [list \
        [list name "#theme-mda.MDA_Theme#"] \
        [list description "#theme-mda.MDA_Theme#"] \
        [list filename ../../theme-mda/lib/themes/mda-theme] \
        [list resource_dir ../../theme-mda/lib/themes/mda-theme]
    ]

    set theme_id [package_instantiate_object -var_list $var_list portal_element_theme]

    set site_template_id [db_nextval acs_object_id_seq]
    db_dml insert_theme {}

	set var_list [list \
        [list name "#theme-mda.MDA_Theme_Terra_legal#"] \
        [list description "#theme-mda.MDA_Theme_Terra_legal#"] \
        [list filename ../../theme-mda/lib/themes/terra-legal-theme] \
        [list resource_dir ../../theme-mda/lib/themes/terra-legal-theme]
    ]

    set theme_id [package_instantiate_object -var_list $var_list portal_element_theme]

    set site_template_id [db_nextval acs_object_id_seq]
    db_dml insert_theme {}



	set var_list [list \
        [list name "#theme-mda.MDA_Theme_Arco_Verde#"] \
        [list description "#theme-mda.MDA_Theme_Arco_Verde#"] \
        [list filename ../../theme-mda/lib/themes/arco-verde-theme] \
        [list resource_dir ../../theme-mda/lib/themes/arco-verde-theme]
    ]

    set theme_id [package_instantiate_object -var_list $var_list portal_element_theme]

    set site_template_id [db_nextval acs_object_id_seq]
    db_dml insert_theme {}



	## create a default style of 4 and 5 regions

	set var_list [list \
        [list name "#new-portal.simple_4column_layout_name#"] \
        [list description "#new-portal.simple_4column_layout_description#"] \
        [list resource_dir "layouts/components/simple4"] \
        [list filename "layouts/simple4"]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 4]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list name "#new-portal.simple_5column_layout_name#"] \
        [list description "#new-portal.simple_5column_layout_description#"] \
        [list resource_dir "layouts/components/simple5"] \
        [list filename "layouts/simple5"]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 4]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list layout_id $layout_id] \
        [list region 5]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region

set var_list [list \
        [list name "#new-portal.simple_66column_layout_name#"] \
        [list description "#new-portal.simple_6column_layout_description#"] \
        [list resource_dir "layouts/components/simple6"] \
        [list filename "layouts/simple6"]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 4]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list layout_id $layout_id] \
        [list region 5]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region

  set var_list [list \
        [list layout_id $layout_id] \
        [list region 6]
    ]

    package_exec_plsql -var_list $var_list portal_layout add_region



}

ad_proc -public theme_mda::apm::before_uninstall {} {
} {
}
