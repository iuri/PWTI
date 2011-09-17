# /types/register-mime-types.tcl
# A form for registering mime types to a content type


request create
request set_param content_type -datatype keyword -value 'content_revision'

permission::require_permission -party_id [auth::require_login] \
    -object_id [cm::modules::get_module_id -module_name types -package_id [ad_conn package_id]] -privilege read

set content_type_name [db_string get_name ""]

set unregistered_mime_types [db_list_of_lists get_unreg_mime_types ""]

set unregistered_mime_types_count [llength $unregistered_mime_types]

if { [template::util::is_nil content_type_name] } {
    ns_log Notice \
      "register-mime-types.tcl - ERROR:  BAD CONTENT_TYPE - $content_type"
    template::forward "index?id=content_revision"
}

template::list::create \
    -name mime_types \
    -multirow registered_mime_types \
    -has_checkboxes \
    -key mime_types \
    -elements {
	label {
	    label "Mime Type"
	}
	unreg {
	    display_template "<a href=\"@registered_mime_types.unreg_url@\">unregister</a>"
	}
    }

db_multirow -extend {unreg unreg_url} registered_mime_types get_reg_mime_types "" {
    set unreg_url [export_vars -base unregister-mime-type {content_type mime_type}]
}
  
set page_title "Register MIME types to $content_type_name"


form create register 
#-action "mime-types"

element create register id \
	-datatype keyword \
	-widget hidden \
	-value $content_type

element create register content_type \
	-datatype keyword \
	-widget hidden \
	-value $content_type

element create register mime_type \
	-datatype text \
	-widget select \
	-label "Register MIME Types" \
	-options $unregistered_mime_types



if { [form is_valid register] } {
    form get_values register content_type mime_type

    db_transaction {

        db_exec_plsql register_mime_type "
      begin
        content_type.register_mime_type (
            content_type => :content_type,
            mime_type    => :mime_type
        );
      end;"

    }

    content_method::flush_content_methods_cache $content_type

    template::forward "index?id=$content_type"
}
