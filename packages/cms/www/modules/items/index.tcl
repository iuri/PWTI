ad_page_contract {
    Assemble information for a content item.  Note this page is only
    appropriate for revisioned content items.  Non-revisioned content
    items (symlinks, extlinks and folders) have separate admin pages

    @author Michael Steigman
    @creation-date May 2005
} {
    { item_id:integer }
    { mount_point:optional "sitemap" }
    { item_props_tab:optional "editing" }
}

set package_url [ad_conn package_url]

# HACK: sometimes the query string does not get parsed when returning
# from revision-add-2.  The reason for this is unclear.
if { [string equal [ns_queryget item_id] {}] } {
  ns_log Notice "ITEM ID NOT FOUND...PARSING QUERY STRING"
  set item_id [lindex [split [ns_conn query] "="] 1]
}

# resolve any symlinks
set resolved_item_id [db_string get_item_id ""]

set item_id $resolved_item_id

set user_id [auth::require_login]
permission::require_permission -party_id $user_id \
    -object_id $item_id -privilege read

set can_edit_p [permission::permission_p -party_id $user_id \
		    -object_id $item_id -privilege write]

# query the content_type of the item ID so we can check for a custom info page
db_1row get_info "" -column_array info
template::util::array_to_vars info

set item_title [db_string get_item_title ""]
set page_title "Content Item - $item_title"

# build the path to the custom interface directory for this content type

set custom_dir [file dirname [ns_conn url]]/custom/$content_type

# check for the custom info page and redirect if found

if { [file exists [ns_url2file $custom_dir/index.tcl]] } {

  template::forward $custom_dir/index?item_id=$item_id
}

# The root ID is to determine the appropriate path to the item

set root_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
