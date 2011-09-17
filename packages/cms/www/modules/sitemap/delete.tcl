ad_page_contract {

    Delete a folder (only if does not contain any items).

} {
    {folder_id:integer}
    {parent_id:integer}
    {mount_point "sitemap"}
}

set user_id [auth::require_login] 
permission::require_permission -party_id $user_id \
    -object_id $parent_id -privilege write

# Determine if the folder is empty
if { [string match [content::folder::is_empty -folder_id $folder_id] "f" ] } {

    util_user_message -message "Folder is not empty. Please delete folder contents and try again."
    ad_returnredirect [export_vars -base ../$mount_point/index {folder_id}]

} else {

    content::folder::delete -folder_id $folder_id
    
    # Remove it from the clipboard, if it exists
    set clip [clipboard::parse_cookie]
    clipboard::remove_item $clip $mount_point $folder_id
    clipboard::set_cookie $clip
    clipboard::free $clip 

    # Redirect to parent folder
    set folder_id $parent_id
    ad_returnredirect [export_vars -base ../$mount_point/index {folder_id}]

}
