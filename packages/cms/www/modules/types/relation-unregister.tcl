# relation-unregister.tcl
# Unregister a relation type from a content type
# @author Michael Pih

request create
request set_param rel_type -datatype keyword -value item
request set_param content_type -datatype keyword
request set_param type_props_tab -datatype keyword -optional -value related
request set_param target_type -datatype keyword
request set_param relation_tag -datatype text -value ""

permission::require_permission -party_id [auth::require_login] \
    -object_id [cm::modules::get_module_id -module_name types -package_id [ad_conn package_id]] -privilege write

if { [string equal $rel_type child_rel] } {

    set unregister_method "unregister_child_type"
    set content_key "parent_type"
    set target_key "child_type"

} elseif { [string equal $rel_type item_rel] } {

    set unregister_method "unregister_relation_type"
    set content_key "content_type"
    set target_key "target_type"

} else {
    # bad rel_type, don't do anything
    template::forward "index?id=$content_type"
}


if { [catch {db_exec_plsql unregister {}} errmsg] } {
    template::request::error unregister_relation_type \
	    "Could not unregister relation type - $errmsg"
}

ad_returnredirect [export_vars -base index {content_type type_props_tab mount_point}]
