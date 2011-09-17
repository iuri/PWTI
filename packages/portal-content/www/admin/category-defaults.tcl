ad_page_contract {
    Set default categories
}

set project_name [portal_content::conn project_name]
set page_title [_ portal-content.lt_Default_Category_Setu]
set context_bar [ad_context_bar [list categories [_ portal-content.Manage_Categories]] $page_title]

array set default_configs [portal_content::get_default_configurations]

set options [list]

foreach name [lsort -ascii [array names default_configs]] {
    lappend options [list $name $name]
}

ad_form -name setup -cancel_url categories -form {
    {setup:text(select) {label "[_ portal-content.Choose_setup]"} {options $options}}
} -on_submit {
    array set config $default_configs($setup)
    
    portal_content::install_keywords_setup -spec $config(categories)
    ad_returnredirect categories
    ad_script_abort
}
