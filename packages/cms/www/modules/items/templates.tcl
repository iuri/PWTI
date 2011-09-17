# /modules/items/templates.tcl
# Display information about templates associated with the item.

request create
request set_param item_id -datatype integer
request set_param mount_point -datatype keyword -optional -value sitemap

set return_url "index?item_id=$item_id&mount_point=sitemap"
set user_id [auth::require_login]
permission::require_permission -party_id $user_id \
    -object_id $item_id -privilege read

# check if the user has write permission on the types module
# MS: for now, we're just going to check if the user has write
# privs on this item (need to think about this)
set can_set_default_template [permission::permission_p \
				  -party_id $user_id \
				  -object_id $item_id \
				  -privilege write]

db_1row get_iteminfo "" -column_array iteminfo

set content_type $iteminfo(object_type)

template::list::create \
    -name registered_templates \
    -multirow registered_templates \
    -has_checkboxes \
    -no_data "No templates registered to this content item" \
    -elements {
	path {
	    label "Path"
	}
	use_context {
	    label "Use Context?"
	}
	action {
	    label "Action"
	    display_template "<a href=@registered_templates.unreg_url@>unregister</a>"
	}
    }

# templates registered to this item
db_multirow -extend {unreg_url context} registered_templates get_reg_templates {
    if {$can_read_template_p} {
	set context $use_context
	set unreg_url [export_vars -base template-unregister {item_id template_id context}]
    }
}

template::list::create \
    -name type_templates \
    -multirow type_templates \
    -has_checkboxes \
    -no_data "No templates registered to this content type" \
    -elements {
	path {
	    label "Path"
	}
	use_context {
	    label "Use Context?"
	}
	set_default_url {
	    label "Default?"
	    display_template {
		<if @type_templates.set_default_url@ not nil>
		no, <a href=@type_templates.set_default_url@>set default</a>
		</if><else>
		yes
		</else>
	    }
	}
	register_template_url {
	    label "Registered?"
	    display_template {
		<if @type_templates.register_template_url@ not nil>
		no, <a href=@type_templates.register_template_url@>register template to this item</a>
		</if><else>
	        yes
		</else>
	    }
	}
    }

# templates registered to this content type
db_multirow -extend { set_default_url register_template_url} type_templates get_type_templates {} {
    set context $use_context
    if {$can_read_template && $can_set_default_template} {
	set set_default_url [export_vars -base ../types/set-default-template {template_id context content_type return_url}]
	if {[string match $already_registered_p f] && {$registered_templates:rowcount == 0}} {
	    set register_template_url [export_vars -base template-register {item_id template_id contex return_url}]
	} else {
	    set register_template_url ""
	}
    } else {
	set set_default_url ""
    }
}
