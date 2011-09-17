# Copy folders under another folder

request create 
request set_param folder_id -datatype integer -optional
request set_param mount_point -datatype keyword -value sitemap


set root_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
if { [template::util::is_nil folder_id] } {
  set folder_id $root_id
} 
# else {
#   set folder_id $id
# }

set user_id [auth::require_login]
permission::require_permission -party_id $user_id \
    -object_id $folder_id -privilege write

set clip [clipboard::parse_cookie]
set clip_items [clipboard::get_items $clip $mount_point]
set clip_length [llength $clip_items]
if { $clip_length == 0 } {
    set no_items_on_clipboard "t"
    return
} else {
    set no_items_on_clipboard "f"
}

set path [db_string get_path ""]

# get relevant marked items
db_multirow marked_items get_marked ""

form create copy
element create copy mount_point \
	-datatype keyword \
	-widget hidden \
	-value $mount_point

element create copy folder_id \
	-datatype integer \
	-widget hidden \
	-param \
	-optional

element create copy copied_items \
	-datatype integer \
	-widget checkbox

set marked_item_size [multirow size marked_items]

for { set i 1 } { $i <= $marked_item_size } { incr i } {
    set title [multirow get marked_items $i title]
    set name [multirow get marked_items $i name]
    set item_id [multirow get marked_items $i item_id]
    set parent_id [multirow get marked_items $i parent_id]
    
    element create copy "parent_id_$item_id" \
	    -datatype integer \
	    -widget hidden

    element set_value copy parent_id_$item_id $parent_id
}







if { [form is_valid copy] } {

    form get_values copy folder_id mount_point
    set copied_items [element get_values copy copied_items]

    db_transaction {

        set folder_flush_list [list]
        foreach cp_item_id $copied_items {
            set parent_id [element get_values copy "parent_id_$cp_item_id"]

            if { [catch {db_exec_plsql copy_item {} } errmsg] } {
                # possibly a duplicate name
                ns_log notice "ERROR: copy.tcl - while copying $errmsg"
            }

        }
    }

    clipboard::free $clip

    ad_returnredirect [export_vars -base index {folder_id mount_point}]

}
