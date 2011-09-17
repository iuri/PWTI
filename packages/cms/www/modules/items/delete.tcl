# Delete a content item and all of its revisions, 

request create
request set_param item_id -datatype keyword
request set_param mount_point -datatype keyword -value sitemap

permission::require_permission -party_id [auth::require_login] \
    -object_id $item_id -privilege write

db_transaction {

    db_exec_plsql item_delete {}

}

ad_returnredirect [export_vars -base "../sitemap/index" {mount_point}]
