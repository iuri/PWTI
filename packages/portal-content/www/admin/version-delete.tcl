ad_page_contract {
    Delete version
} {
    version_id:integer
}

db_dml delete_version {}

portal_content::versions_flush
    
ad_returnredirect versions
