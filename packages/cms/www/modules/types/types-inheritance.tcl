request create
request set_param content_type -datatype text -value content_revision

# get all the content types that this content type inherits from
db_multirow content_type_tree get_content_type ""