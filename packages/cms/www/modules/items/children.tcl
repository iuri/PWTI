# Display information about items for which the item is the context.

# page variables
request create -params {
  item_id -datatype integer
  mount_point -datatype keyword -optional -value sitemap
}

set user_id [auth::require_login]
permission::require_permission -party_id $user_id \
    -object_id $item_id -privilege read

# create a form to add child items...
set child_types [db_list_of_lists get_child_types ""]

# but do not display form if this content type does not allow children
set child_types_registered_p [llength $child_types]

if { [permission::permission_p -party_id $user_id -object_id $item_id -privilege write] } {
    form create add_child -method get -action create-1
    element create add_child parent_id -datatype integer \
	-widget hidden -value $item_id
    element create add_child content_type -datatype keyword \
	-options $child_types -widget select 
}

template::list::create \
    -name children \
    -key rel_id \
    -no_data "No child items" \
    -multirow children \
    -actions [list "Relate marked items to this item" \
		  "relate-items?item_id=$item_id" \
		  "Relate marks items to this item"] \
    -bulk_actions [list "Remove marked relations" \
		       "[export_vars -base unrelate-item?mount_point=sitemap { rel_id }]" \
		       "Remove marked relations from this item"] \
    -elements {
	content_type {
	    label "Content Type"
	}
	title_url {
	    label "Title"
	    display_template "<a href=\"@children.title_url@\" title=\"View content item\">@children.title@</a>"
	}
	type_name {
	    label "Relationship Type"
	}
	tag {
	    label "Tag"
	}
	reorder {
	    label "Move"
	    display_template "<nobr><a href=\"@children.move_up_url@\" title=\"Move item up\">up</a> &nbsp;|&nbsp; \
                                    <a href=\"@children.move_down_url@\" title=\"Move item down\">down</a></nobr>"
	}
    }    

db_multirow -extend { title_url relation_view_url move_up_url move_down_url reorder } children get_children "" {
    set title_url "index?item_id=$item_id&mount_point=$mount_point"
    set move_up_url "relate-order?rel_id=$rel_id&order=up&mount_point=$mount_point&item_props_tab=children&relation_type=relation"
    set move_down_url "relate-order?rel_id=$rel_id&order=down&mount_point=$mount_point&item_props_tab=children&relation_type=relation"
}
