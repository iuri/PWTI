ad_page_contract {
    List contents of a folder
    List path of this folder
    List path of any symlinks to this folder


    @author Michael Steigman
    @creation-date October 2004
} {
    { folder_id:integer ""}
    { mount_point:optional "sitemap" }
    { parent_id:integer ""}
    { orderby "title,asc" }
    { page:optional ""}
}

set original_folder_id $folder_id
set user_id [auth::require_login]
set package_id [ad_conn package_id]
set root_id [cm::modules::${mount_point}::getRootFolderID $package_id]

# Get the folder label/description
#   If :id does not exist, then use :root_id
if { [template::util::is_nil folder_id] } {
    set parent_var :root_id
    #set parent_id $root_id
    set folder_id $root_id
    permission::require_permission -party_id $user_id \
	-object_id $folder_id -privilege read

    set module_name [db_string get_module_name ""]
    
    set info(label) $module_name
    set info(description) ""
    set what "Folder"
    set is_symlink f
    
    # get all the content types registered to this folder
    # check whether this folder allows subfolders, symlinks, and templates
    set registered_types [db_list get_reg_types ""]
    
    set subfolders_allowed f
    set symlinks_allowed f
    set templates_allowed f
    if { [lsearch -exact $registered_types "content_folder"] != -1 } {
	set subfolders_allowed t
    }
    if { [lsearch -exact $registered_types "content_symlink"] != -1 } {
	set symlinks_allowed t
    }
    if { [lsearch -exact $registered_types "content_template"] != -1 } {
	set templates_allowed t
    }
    
} else {
    
    permission::require_permission -party_id $user_id \
	    -object_id $folder_id -privilege read
    
    set parent_var :folder_id
    
    # Resolve the symlink, if any
    set resolved_id [db_string get_resolved_id ""]
    
    if { $resolved_id != $folder_id } {
	set is_symlink t
	set item_id $resolved_id
	set what "Link"
    } else {
	set is_symlink f
	set what "Folder"
    }
    
    # get all the content types registered to this folder
    # check whether this folder allows subfolders, symlinks, and templates
    set registered_types [db_list get_types ""]
    
    set subfolders_allowed f
    set symlinks_allowed f
    set templates_allowed f
    if { [lsearch -exact $registered_types "content_folder"] != -1 } {
	set subfolders_allowed t
    }
    if { [lsearch -exact $registered_types "content_symlink"] != -1 } {
	set symlinks_allowed t
    }
    if { [lsearch -exact $registered_types "content_template"] != -1 } {
	set templates_allowed t
    }
    
}

db_1row get_info "" -column_array info
if { $info(parent_id) == 0  } {
    # at root; this will change once inheritance is set up for modules
    set parent_id ""
} else {
    set parent_id $info(parent_id)
}

# Get the index page ID

set index_page_id [db_string get_index_page_id ""]

# symlinks to this folder/item
db_multirow symlinks get_symlinks ""

# build folder contents list

set page_title "Content Folder - $info(label)"

set actions "Attributes [export_vars -base attributes?mount_point=sitemap {folder_id}] \"Folder Attributes\""
if { [permission::permission_p -party_id $user_id \
	  -object_id $folder_id -privilege write] } {
    append actions "
\"Delete Folder\" [export_vars -base delete?mount_point=sitemap {folder_id parent_id}] \"Delete this folder\"
\"Rename Folder\" [export_vars -base rename?mount_point=sitemap {folder_id}] \"Rename this folder\"
\"New Folder\" [export_vars -base create?mount_point=sitemap {folder_id}] \"Create a new folder within this folder\"
\"Move Items\" [export_vars -base move?mount_point=sitemap {folder_id}] \"Move marked items to this folder\"
\"Copy Items\" [export_vars -base copy?mount_point=sitemap {folder_id}] \"Copy marked items to this folder\"
\"Link Items\" [export_vars -base symlink?mount_point=sitemap {folder_id}] \"Link marked items to this folder\"
\"Delete Items\" [export_vars -base delete-items?mount_point=sitemap {folder_id}] \"Delete marked items\"
"
} 

form create add_item

if { [template::util::is_nil original_folder_id] } {
    set the_id $root_id
} else {
    set the_id $original_folder_id
}

element create add_item folder_id \
	-datatype integer -widget hidden -param -optional

element create add_item mount_point \
	-datatype string -widget hidden -value $mount_point

set revision_types [list [list "----------------" ""]]
append revision_types " "
append revision_types [cms_folder::get_registered_types $the_id]
set num_revision_types [llength $revision_types]

element create add_item content_type \
    -datatype keyword \
    -widget select \
    -label "Content Type" \
    -options $revision_types \
    -html { onchange "javascript:this.form.submit();" }

if { [form is_valid add_item] } {
    form get_values add_item folder_id mount_point content_type

    # if the folder_id is empty, then it must be the root folder
    if { [template::util::is_nil folder_id] } {
	set folder_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
    } else {
	set folder_id $original_folder_id
    }

    if { [string equal $mount_point "templates"] } {
	forward "../items/template?parent_id=$folder_id&mount_point=$mount_point"
    } else {
 	forward "../items/create-1?parent_id=$folder_id&mount_point=$mount_point&content_type=$content_type"
    }
}

