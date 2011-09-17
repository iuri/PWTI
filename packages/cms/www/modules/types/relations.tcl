# relations.tcl
# display registered relation types
# @author Michael Pih

request create
request set_param content_type -datatype integer -value content_revision
request set_param type_props_tab -datatype text -optional -value attributes

permission::require_permission -party_id [auth::require_login] \
    -object_id [cm::modules::get_module_id -module_name types -package_id [ad_conn package_id]] -privilege read

template::list::create \
    -name rel_types \
    -multirow rel_types \
    -has_checkboxes \
    -no_data "There are no item relation types registered to this content type." \
    -actions [list "Register a new item relation type" [export_vars -base relation-register?rel_type=item_rel {content_type type_props_tab}] "Register a new item relation type"] \
    -elements {
        pretty_name {
	    label "Related Object Type"
	}
	relation_tag {
	    label "Relation Tag"
	}
	min_n {
	    label "Min Relations"
	}
	max_n {
	    label "Max Relations"
	}
	item_unreg_link {
	    display_template "<center><a href=\"@rel_types.item_unreg_link;noquote@\">unregister</a></center>"
	}
	
    }

db_multirow -extend {item_unreg_link} rel_types get_rel_types "" {
    set rel_type item_rel
    set item_unreg_link [export_vars -base relation-unregister {rel_type content_type target_type relation_tag type_props_tab}]
}

template::list::create \
    -name child_types \
    -multirow child_types \
    -has_checkboxes \
    -no_data "There are no child relation types registered to this content type." \
    -actions [list "Register a new child relation type" [export_vars -base relation-register?rel_type=child_rel {content_type type_props_tab}] "Register a new child relation type"] \
    -elements {
        pretty_name {
	    label "Child Type"
	}
	relation_tag {
	    label "Relation Tag"
	}
	min_n {
	    label "Min Relations"
	}
	max_n {
	    label "Max Relations"
	}
	child_unreg_link {
	    display_template "<center><a href=\"@child_types.child_unreg_link;noquote@\">unregister</a></center>"
	}
	
    }

db_multirow -extend {child_unreg_link} child_types get_child_types "" {
    set rel_type child_rel
    set target_type $child_type
    set child_unreg_link [export_vars -base relation-unregister {rel_type content_type target_type relation_tag type_props_tab}]
}
