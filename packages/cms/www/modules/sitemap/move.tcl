# Move folders under another folder

request create 
request set_param id -datatype integer -optional
request set_param mount_point -datatype keyword -value sitemap


set root_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
if { [template::util::is_nil id] } {
  set folder_id $root_id
} else {
  set folder_id $id
}

permission::require_permission -party_id [auth::require_login] \
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

ns_log Notice "path = $path"

# get relevant marked items
db_multirow marked_items get_marked ""

form create move
element create move mount_point \
	-datatype keyword \
	-widget hidden \
	-value $mount_point

element create move id \
	-datatype integer \
	-widget hidden \
	-param \
	-optional


element create move moved_items \
	-datatype integer \
	-widget checkbox

set marked_item_size [multirow size marked_items]

for { set i 1 } { $i <= $marked_item_size } { incr i } {
    set title [multirow get marked_items $i title]
    set name [multirow get marked_items $i name]
    set item_id [multirow get marked_items $i item_id]
    set parent_id [multirow get marked_items $i parent_id]
    
    element create move parent_id_$item_id \
	    -datatype integer \
	    -widget hidden

    # need to do this to get around negative values
    element set_value move parent_id_$item_id $parent_id
}

if { [form is_valid move] } {

    set root_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]

    form get_values move id mount_point
    set moved_items [element get_values move moved_items]

    db_transaction {
        set folder_flush_list [list]
        foreach mv_item_id $moved_items {
            set parent_id [element get_values move "parent_id_$mv_item_id"]

            if { [catch {db_exec_plsql move_items {} } errmsg] } {
                # possibly a duplicate name
                ns_log notice "move.tcl - while moving $errmsg"
            }
	}
    }

    clipboard::free $clip

    ad_returnredirect [export_vars -base index {folder_id mount_point}]

}
