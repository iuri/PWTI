ad_page_contract {
    List the contents of a folder under in the template repository
    Either a path or a folder ID may be passed to the page.

    @author Michael Steigman
    @creation-date October 2004
} {
    { item_id:integer ""}
    { path:optional "" }
    { mount_point "templates"}
    { template_props_tab:optional "revisions"}
}

if { ! [string equal $path {}] } {

    set item_id [db_string get_id ""]

    if { [string equal $item_id {}] } {

        set msg "The requested folder <tt>$path</tt> does not exist."
        request error invalid_path $msg
    }

} else {

  if { [string equal $item_id {}] } {
      set id [db_string get_root_id ""]
  }

  set path [db_string get_path ""]
}

# query for the content type and redirect if a folder

set type [db_string get_type ""]

if { [string equal $type content_folder] } {
  template::forward index?id=$item_id
}

# query the content_type of the item ID so we can check for a custom info page
db_1row get_info "" -column_array info
template::util::array_to_vars info

set item_title [db_string get_item_title ""]
set page_title "Content Template - $item_title"

