request create -params {
    item_id -datatype integer
    mount_point -datatype keyword -optional -value templates
    template_props_tab -datatype keyword -optional -value revisions
}

# query the content_type of the item ID so we can check for a custom info page
db_1row get_info "" -column_array info
template::util::array_to_vars info

set item_title [db_string get_item_title ""]
set page_title "Content Template - $item_title"