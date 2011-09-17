ad_page_contract {
    Initial project setup
}

set project_name [portal_content::conn project_name]
set page_title [_ portal-content.Initial]
set context_bar [ad_context_bar $page_title]

array set default_configs [portal_content::get_default_configurations]

set options [list]

foreach name [lsort -ascii [array names default_configs]] {
    lappend options [list $name $name]
}
lappend options [list "[_ portal-content.Custom]" "custom"]

ad_form -name setup -cancel_url . -form {
    {setup:text(select) {label "[_ portal-content.Choose]"} {options $options}}
} -on_submit {
    if { [info exists default_configs($setup)] } {
        array set config $default_configs($setup)

        portal_content::delete_all_project_keywords
        portal_content::install_keywords_setup -spec $config(categories)
        portal_content::install_parameters_setup -spec $config(parameters)
    }
} -after_submit {
    ad_returnredirect .
    ad_script_abort
}
