# Refresh the tree to show any new folders

request create
request set_param item_id -datatype keyword -optional
request set_param mount_point -datatype keyword -optional -value sitemap
request set_param goto_id -datatype keyword -optional
set user_id [auth::require_login]

# Change the update time on the folder
refreshCachedFolder $user_id sitemap $id

if { [template::util::is_nil goto_id] } {
  set goto_id $item_id
} else {
  refreshCachedFolder $user_id $mount_point $goto_id
}



