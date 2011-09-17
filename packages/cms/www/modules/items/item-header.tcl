request create
request set_param item_id -datatype integer
request set_param mount_point -datatype keyword -optional -value sitemap

# query the content_type of the item ID so we can check for a custom info page
db_1row get_info "" -column_array info
template::util::array_to_vars info

set page_title "Content Item - $title"
