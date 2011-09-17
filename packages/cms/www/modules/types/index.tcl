# ad_page_contract {

#     @author Michael Steigman (michael@steigman.net)
#     @creation-date October 2004
# } {
#     {content_type:optional "content_revision"}
#     {parent_type ""}
#     {mount_point:optional "types"}
#     {type_props_tab:optional "attributes"}
# }

#query for attributes of this subclass of content_revision and display them

request create
request set_param content_type -datatype keyword -value content_revision
request set_param parent_type -datatype keyword -optional
request set_param mount_point -datatype keyword -value types
request set_param type_props_tab -datatype keyword -optional -value attributes

set root_id [cm::modules::templates::getRootFolderID [ad_conn package_id]]

set user_id [auth::require_login]
set module_id [cm::modules::get_module_id -module_name types -package_id [ad_conn package_id]]
permission::require_permission -party_id $user_id \
    -object_id $module_id -privilege read

set can_edit_widgets_p [permission::permission_p -party_id $user_id \
    -object_id $module_id -privilege write]

# get the content type pretty name
set object_type_pretty [db_string get_object_type ""]
set page_title "Content Type - $object_type_pretty"

if { [string equal $object_type_pretty ""] } {
    # error - invalid content_type
    template::forward index
}


# get all the content types that this content type inherits from
db_multirow content_type_tree get_content_type ""

template::list::create \
    -name type_templates \
    -multirow type_templates \
    -has_checkboxes \
    -no_data "There are no templates registered to this content type." \
    -actions [list "Register marked templates to this content type" [export_vars -base register-templates {content_type type_props_tab}] "Register marked templates to this content type"] \
    -elements {
        name {
	    label "Template Name"
	}
	path {
	    label "Path"
	}
	pretty_name {
	    label "Content Type"
	}
	use_context {
	    label "Context"
	}
	is_default {
	    label "Default?"
	    display_template "<if @type_templates.is_default@ eq t>Yes</if><else><a href=\"@type_templates.set_default_url@\">set as default</a></else>"
	}
	unreg_link {
	    display_template "<center><a href=\"@type_templates.unreg_link_url;noquote@\">unregister</a></center>"
	}
	
    }

# get template information
db_multirow -extend {unreg_link unreg_link_url set_default_url} type_templates get_type_templates "" {
    set context $use_context
    set unreg_link_url [export_vars -base unregister-template {template_id context content_type type_props_tab}]
    set set_default_url [export_vars -base set-default-template {template_id context content_type type_props_tab}]
}
