ad_page_contract {
    List the contents of a folder under in the template repository
    Either a path or a folder ID may be passed to the page.

    @author Michael Steigman
    @creation-date October 2004
} {
    { folder_id:integer ""}
    { mount_point "templates" }
    { parent_id:integer ""}
    { orderby "title,asc" }
    { page:optional ""}
    { path:optional "" }
}

set package_url [ad_conn package_url]
set clipboardfloats_p [clipboard::floats_p]

if { ! [string equal $path {}] } {

    set item_id [db_string get_id ""]

    if { [string equal $folder_id {}] } {

        set msg "The requested folder <tt>$path</tt> does not exist."
        request error invalid_path $msg
    }
} else {

  if { [string equal $folder_id {}] } {
      set folder_id [cm::modules::templates::getRootFolderID [ad_conn package_id]]
  }

  set path [db_string get_path ""]
}

# query for the content type and redirect if a folder
set type [db_string get_type ""]

if { [string equal $type content_template] } {
  template::forward properties?item_id=$item_id
}

db_1row get_info "" -column_array info

set page_title "Template Folder - $info(label)"

#set folder_id $item_id
#set parent_id $item_id

set actions "Attributes [export_vars -base ../sitemap/attributes?mount_point=templates {folder_id}] \"Folder Attributes\"
\"Delete Folder\" [export_vars -base ../sitemap/delete?mount_point=templates {folder_id parent_id}] \"Delete this folder\"
\"Rename Folder\" [export_vars -base ../sitemap/rename?mount_point=templates {folder_id}] \"Rename this folder\"
\"New Template\" [export_vars -base new-template?mount_point=templates {folder_id}] \"Create a new template within this folder\"
\"New Folder\" [export_vars -base new-folder?mount_point=templates {parent_id}] \"Create a new folder within this folder\"
\"Move Items\" [export_vars -base move?mount_point=templates {folder_id}] \"Move folder\"
\"Copy Items\" [export_vars -base copy?mount_point=templates {folder_id}] \"Copy folder\"
\"Delete Items\" [export_vars -base delete?mount_point=templates {folder_id}] \"Delete folder\"
"

