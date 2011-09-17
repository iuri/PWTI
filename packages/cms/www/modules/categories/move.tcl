# Move selected keywords into the target category

request create
# Move marked keywords into this category
request set_param target_id -datatype integer
# Mount point for the tree
request set_param mount_point -datatype keyword -optional \
  -value "categories"
# Parent id for the tree
request set_param parent_id -datatype integer -optional

if { [template::util::is_nil target_id] } {
  set update_value "null"
} else {
  set update_value "$target_id"
}

set clip [clipboard::parse_cookie]

db_transaction {

    clipboard::map_code $clip $mount_point {
        if { [catch { 
            db_dml move_keyword_item {}
            db_dml move_keyword_keyword {}
            db_dml update_context_id {}
        } errmsg] } {
        }    
    }
}

clipboard::free $clip

set id $target_id
ad_returnredirect [export_vars -base index {id mount_point}]



 
  
  
  

