# View a particular revision of the item.

request create -params {
  revision_id -datatype integer
  mount_point -datatype keyword -value sitemap
}

# flag indicating this is the live revision
set live_revision_p 0

db_1row get_revision "" -column_array one_revision
template::util::array_to_vars one_revision

set user_id [auth::require_login]
permission::require_permission -party_id $user_id \
    -object_id $item_id -privilege read

set write_p [permission::permission_p -party_id $user_id \
		 -object_id $item_id -privilege write]
# validate revision
if { [template::util::is_nil item_id] } {
    template::request::error invalid_revision \
      "revision - Invalid revision - $revision_id"
    return
}

# check if the item is publishable (but does not need live revision)
set is_publishable [db_string get_status ""]

# get total number of revision for this item
set revision_count [db_string get_count ""]

set valid_revision_p "t"

# flag indicating whether the MIME type of the content is text
set is_text_mime_type f
set is_image_mime_type f

if { [string match "text/*" $mime_type] } {
    set is_text_mime_type t
    set content [db_string get_content ""]
} elseif { [string match "image/*" $mime_type] } {
    set is_image_mime_type t
}
ns_log notice "----- $is_text_mime_type $is_image_mime_type $valid_revision_p $is_publishable $write_p $revision_count"
# get item info
db_1row get_one_item ""
    
if { $live_revision_id == $revision_id } {
  set live_revision_p 1
}

set page_title "$title : Revision $revision_number of $revision_count for $name"

