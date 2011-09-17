ad_page_contract {
    Display content types that are registered to this folder

    @author Michael Steigman
    @creation-date October 2004
} {
    { folder_id:integer,optional }
    { folder_resolved_id:integer,optional}
    { mount_point "sitemap" }
}

# default folder_id is the root folder
if { [template::util::is_nil folder_id] } {
    set folder_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
}

if { [template::util::is_nil folder_resolved_id] } {
    set folder_resolved_id $folder_id
}

permission::require_permission -party_id [auth::require_login] \
    -object_id $folder_id -privilege read

# Get the registered types for the folder 
# (besides symlinks/templates/subfolders)
cms_folder::get_registered_types $folder_id multirow content_types

#set type-unreg-url 
template::list::create \
    -name content_types \
    -multirow content_types \
    -key content_type \
    -bulk_actions [list	"Unregister checked types from this folder" \
		       "[export_vars -base type-unregister?mount_point=sitemap {folder_id}]" \
		       "Unregister checked types from this folder"] \
    -bulk_action_export_vars folder_id \
    -actions [list "Register content types on clipboard to this folder" \
		  [export_vars -base type-register?mount_point=sitemap {folder_id}] "Register clipped content types to this folder"] \
    -elements {
	pretty_name {
	    label "Content Type"
	}
	
    }


# Get other misc values
set folder_name [db_string get_folder_name ""]

set page_title "Folder Attributes - $folder_name"

# Set up passthrough for permissions
set return_url [ns_conn url]
set passthrough [content::assemble_passthrough \
                  return_url mount_point folder_id]


# Determine registered types
db_1row get_options "" -column_array folder_options

# Create the form for registering special types to the folder
ad_form -name special_types \
    -form {
	{allow_subfolders:boolean(radio)
	    {label "Allow Subfolders?"}
	    {options {{Yes t} {No f}}}
	    {values $folder_options(allow_subfolders)}
	}
	{allow_symlinks:boolean(radio)
	    {label "Allow Symlinks?"}
	    {options {{Yes t} {No f}}}
	    {values $folder_options(allow_symlinks)}
	}
	{folder_resolved_id:integer(hidden),optional}
	{mount_point:text(hidden)}
	{folder_id:integer(hidden)}
    } \
    -on_request {}\
    -on_submit {

	permission::require_permission -party_id [auth::require_login] \
	    -object_id $folder_id -privilege write

        if { [string equal $allow_subfolders "t"] } {
            set subfolder_method "register_content_type"
        } else {
            set subfolder_method "unregister_content_type"
        }
	
        if { [string equal $allow_symlinks "t"] } {
            set symlink_method "register_content_type"
        } else {
            set symlink_method "unregister_content_type"
        }
	
        db_exec_plsql content ""
    } \
    -after_submit {
	ad_returnredirect [export_vars -base attributes {folder_id mount_point}]
	ad_script_abort
    }
