ad_page_contract {
    Edit a nonversioned item

    @author Ben Adida
    @creation-date 01 April 2002
    @cvs-id $Id: simple-edit-2.tcl,v 1.4 2005/05/26 08:28:46 maltes Exp $
} {
    object_id:notnull
    url
    name
    description
} 

# Check for write permission on this folder
ad_require_permission $object_id write

# edit the URL
content_extlink::edit -extlink_id $object_id -url $url -label $name -description $description

set folder_id [db_string select_folder_id {}]

ad_returnredirect "?folder_id=$folder_id"

