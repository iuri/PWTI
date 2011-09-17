# /items/rename.tcl
# Change name of a content item

request create
request set_param item_id -datatype integer
request set_param mount_point -datatype text -value sitemap
request set_param item_props_tab -datatype text

permission::require_permission -party_id [auth::require_login] \
    -object_id $item_id -privilege read

set item_name [db_string get_item_name ""]

set page_title "Rename $item_name"

form create rename_item 

element create rename_item mount_point \
    -datatype text \
    -widget hidden \
    -value $mount_point \
    -optional

element create rename_item item_id \
    -datatype integer \
    -widget hidden \
    -param

element create rename_item name \
    -label "Rename $item_name to" \
    -datatype keyword \
    -widget text \
    -html { size 20 } \
    -validate { { expr ![string match $value "/"] } \
		    { Item name cannot contain slashes }} \
    -value $item_name \
    -help_text "Short name using no special characters"

# Rename
if { [form is_valid rename_item] } {

  form get_values rename_item \
	  mount_point item_id name

  db_transaction {
      db_exec_plsql rename_item "
    begin 
    content_item.edit_name (
        item_id => :item_id, 
        name    => :name 
    ); 
    end;"

      set parent_id [db_string get_parent_id ""]
  }

  # flush cache
  cms_folder::flush $mount_point $parent_id

  template::forward "index?item_id=$item_id"
}
