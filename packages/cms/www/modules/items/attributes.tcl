# display the attributes of an item

request create -params {
  revision_id -datatype integer
  mount_point -datatype keyword -optional -value sitemap
}

# query the content type and table so we know which view to examine

db_0or1row get_type_info "" -column_array type_info

if { ! [info exists type_info(table_name)] } {
  adp_abort
  request error revision_id "Invalid Revision ID $revision_id"
  return
}

#  query the row from the standard view

db_0or1row get_info "" -column_array info

if { ! [info exists info(item_id)] } {

  request error revision_id "Attributes for Revision ID
    $revision_id appear to be incomplete.  Each revision must have a 
    row in the storage table for its own content type, as well as in
    the storage table of all the supertypes of its content type."

  return
}

permission::require_permission -party_id [auth::require_login] \
    -object_id $info(item_id) -privilege read

# query the attributes for this content type

set content_type $type_info(object_type)

template::list::create \
    -name attributes \
    -multirow attributes \
    -actions [list "Edit item attributes" \
		  "attributes-edit?item_id=$info(item_id)" \
		  "Edit item attributes"] \
    -elements {
	attribute_label {
	    label "Attribute"
	}
	attribute_value {
	    label "Value"
	    display_template "@attributes.attribute_value;noquote@"
	    html { width 50% }
	}
	object_label {
	    label "Origin"
	    html { width 10% }
	}
    }

db_multirow -extend { attribute_value } attributes get_attributes "" {

    if { [catch { set value $info($attribute_name) } errmsg] } {
	# catch - value doesn't exist
	set value "-"
    } 

    if { [string equal $value {}] } {
        set value "-" 
    }

    set attribute_value [string_truncate $value]
}

