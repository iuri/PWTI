request create -params {
    can_edit_widgets -datatype keyword -optional
    content_type -datatype keyword -optional
}

template::list::create \
    -name attribute_types \
    -multirow attribute_types \
    -has_checkboxes \
    -elements {
	attribute_name_pretty {
	    label "Attribute Name"
	}
	pretty_name {
	    label "Object Type"
	}
	datatype {
	    label "Data Type"
	}
	widget {
	    label "Widget"
	}
	widget_links {
	    display_template "<center>@attribute_types.widget_links;noquote@</center>"
	}
    }

# get all the attribute properties for this object_type
db_multirow -extend { widget_links } attribute_types get_attr_types "" {
    set edit_widget_url [export_vars -base widget-register {attribute_id widget content_type }]
    set unregister_widget_url [export_vars -base widget-unregister {attribute_id content_type}]
    if {$can_edit_widgets_p} {
	if {[string match $object_type $content_type] && [expr ! [string match $object_type "content_revision"]]} {
	    if {[template::util::is_nil widget]} {
		set widget_links "<a href=\"$edit_widget_url\">Register Widget</a>"
	    } else {
		set widget_links "\[ <a href=\"$edit_widget_url\">Edit Widget</a> | <a href=\"$unregister_widget_url\">Unregister Widget</a> \]"
	    }
	}
    }

}
