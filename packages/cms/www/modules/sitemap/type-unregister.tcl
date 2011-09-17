ad_page_contract {
    Unregister a content type from a folder

    @author Michael Steigman
    @creation-date October 2004
} {
    { folder_id:integer }
    { content_type:multiple }
}

foreach type $content_type {
    db_exec_plsql unregister ""
}

cms_folder::flush_registered_types $folder_id

ns_returnredirect "attributes?folder_id=$folder_id"
