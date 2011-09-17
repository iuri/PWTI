request create -params {
    item_id -datatype integer
    mount_point -datatype text -optional -value templates
    template_props_tab -datatype text
}

set package_url [ad_conn package_url]
