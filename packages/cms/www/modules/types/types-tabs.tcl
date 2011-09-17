request create
request set_param content_type -datatype keyword -value content_revision
request set_param parent_type -datatype keyword -optional
request set_param mount_point -datatype keyword -value types
request set_param type_props_tab -datatype keyword -optional -value attributes

set package_url [ad_conn package_url]
