request create
request set_param content_type -datatype keyword -value content_revision
request set_param parent_type -datatype keyword -optional
request set_param mount_point -datatype keyword -value types
request set_param type_props_tab -datatype keyword -optional -value attributes

# get the content type pretty name
set object_type_pretty [db_string get_object_type ""]
set page_title "Content Type - $object_type_pretty"