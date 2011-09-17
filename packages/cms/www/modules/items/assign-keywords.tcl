# Assign marked keywords to item

request create -params {
  id -datatype keyword
  mount_point -datatype keyword -optional -value sitemap
  parent_id -datatype keyword -optional
}

set folder_list [list]

permission::require_permission -party_id [auth::require_login] \
    -object_id $id -privilege write

if { [template::util::is_nil id] } {
  set root_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
} else {
  set root_id $id
}

set clip [clipboard::parse_cookie]

db_transaction {
    clipboard::map_code $clip categories {
        if { [catch { 
            db_exec_plsql item_assign {}
            lappend folder_list [list $mount_point $item_id]
        } errmsg] } {
        }    
    }

}

clipboard::free $clip

# Specify a null id so that the entire branch will be refreshed
template::forward "index?item_id=$id&mount_point=$mount_point"


 
  
  
  
