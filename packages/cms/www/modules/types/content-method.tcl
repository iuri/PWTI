request create
request set_param content_type -datatype keyword -value content_revision
request set_param return_url -datatype text -value ""

# permissions check - user must have read on the types module
permission::require_permission -party_id [auth::require_login] \
    -object_id [cm::modules::get_module_id -module_name types -package_id [ad_conn package_id]] -privilege read

# default return_url
if { [template::util::is_nil return_url] } {
    set return_url "index?id=$content_type"
}

template::list::create \
    -name content_methods \
    -multirow content_methods \
    -has_checkboxes \
    -no_data "There are no content methods registered to this content type. By default, all content methods will be available to this content type." \
    -elements {
	content_method {
	    label "Content Method"
	}
	description {
	    label "Description"
	}
	pretty_is_default {
	    label "Is default?"
	}
	unreg_default_links {
	    display_template "<center>@content_methods.unreg_default_links;noquote@</center>"
	}
	
    }

# fetch the content methods registered to this content type
db_multirow -extend {pretty_is_default unreg_default_links} content_methods get_methods "" {
    set content_method_unset_default_url [export_vars -base content-method-unset-default {content_type}]
    set content_method_set_default_url [export_vars -base content-method-set-default {content_type content_method}]
    set content_method_unregister_url [export_vars -base content-method-unregister {content_type content_method}]

    set unreg_default_links "\[ "
    if {[string match $is_default "t"]} {
	set pretty_is_default "Yes"
	append unreg_default_links "<a href=\"$content_method_unset_default_url\">unset default</a>"
    } else {
    	set pretty_is_default "No"
	append unreg_default_links "<a href=\"$content_method_set_default_url\">set as default</a>"
    }

    append unreg_default_links " | <a href=\"$content_method_unregister_url\">unregister</a> ]"

}

# text_entry content method filter
# don't show text entry if a text mime type is not registered to the item
set has_text_mime_type [db_string check_status ""]

if { $has_text_mime_type == 0 } {
    set text_entry_filter_sql "and content_method != 'text_entry'"
} else {
    set text_entry_filter_sql ""
}


# fetch the content methods not register to this content type
set unregistered_content_methods [db_list_of_lists get_unregistered_methods ""]

set unregistered_method_count [llength $unregistered_content_methods]


# form to register unregistered content methods to this content type
form create register

element create register content_type \
	-datatype keyword \
	-widget hidden \
	-value $content_type

element create register return_url \
	-datatype text \
	-widget hidden \
	-value $return_url

element create register content_method \
	-datatype keyword \
	-widget select \
	-options $unregistered_content_methods
	
element create register submit \
	-datatype keyword \
	-widget submit \
	-label "Register"



if { [form is_valid register] } {

    form get_values register content_type content_method
    
    db_transaction {

        db_exec_plsql add_method "
      begin
      content_method.add_method (
          content_type   => :content_type,
          content_method => :content_method,
          is_default     => 'f'
      );
      end;
    "
    }

    content_method::flush_content_methods_cache $content_type

    template::forward $return_url
}
