# symlink.tcl
# Create symlink for each marked item under this folder


request create 
# current (destination) folder
request set_param id -datatype integer -optional
request set_param mount_point -datatype keyword -value sitemap



if { [template::util::is_nil id] } {
    set folder_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
} else {
    set folder_id $id
}

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

# get title, name, item_id of each marked item
db_multirow marked_items get_marked ""


form create symlink

element create symlink mount_point \
	-datatype keyword \
	-widget hidden \
	-value $mount_point

element create symlink id \
	-datatype integer \
	-widget hidden \
	-param \
	-optional

#element set_value symlink id $folder_id


element create symlink symlinked_items \
	-datatype integer \
	-widget checkbox

set marked_item_size [multirow size marked_items]

for { set i 1 } { $i <= $marked_item_size } { incr i } {
    set title [multirow get marked_items $i title]
    set name [multirow get marked_items $i name]
    set item_id [multirow get marked_items $i item_id]
    
    set element_name_1 "name_$item_id"
    set element_name_2 "title_$item_id"

    element create symlink $element_name_1 \
	    -datatype keyword \
	    -widget text \
	    -value $name

    element create symlink $element_name_2 \
	    -datatype text \
	    -widget text \
	    -value $title

}





if { [form is_valid symlink] } {

    form get_values symlink id mount_point
    set symlinked_items [element get_values symlink symlinked_items]

    db_transaction {
        foreach sym_item_id $symlinked_items {
            set element_name_1 "name_$sym_item_id"
            set element_name_2 "title_$sym_item_id"

            set name [element get_values symlink $element_name_1]
            set label [lindex [element get_values symlink $element_name_2] 0]

            if { [catch {db_exec_plsql new_link {} } errmsg] } {
                # possibly a duplicate name
                ns_log notice "symlink.tcl - while symlinking $errmsg"
            }

        }

    }

    clipboard::free $clip

    ad_returnredirect [export_vars -base index {folder_id mount_point}]

}
