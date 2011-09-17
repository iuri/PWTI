# Change name, label and description of folder.

request create
request set_param folder_id -datatype integer
request set_param mount_point -datatype keyword -value sitemap

permission::require_permission -party_id [auth::require_login] \
    -object_id $folder_id -privilege write

# Create then form
form create rename_folder

element create rename_folder folder_id \
  -datatype integer -widget hidden -param

element create rename_folder parent_id \
  -datatype integer -widget hidden -optional -param

element create rename_folder mount_point \
  -datatype keyword -widget hidden -value $mount_point

element create rename_folder name \
  -label "Name" -datatype url -widget text -html { size 20 } \
  -validate { { expr ![string match $value "/"] } 
              { Folder name cannot contain slashes }}

element create rename_folder label \
  -label "Label" -widget text -datatype text \
  -html { size 30 } -optional

element create rename_folder description \
  -label "Description" -widget textarea -datatype text \
  -html { rows 5 cols 40 wrap physical } -optional


if { [form is_request rename_folder] } {
  
  set folder_id [element get_value rename_folder folder_id]

  # Get existing folder parameters
  db_1row get_info "" -column_array info

  element set_properties rename_folder name -value $info(name)
  element set_properties rename_folder label -value $info(label)
  element set_properties rename_folder description -value $info(description)
}

# Rename
if { [form is_valid rename_folder] } {

  form get_values rename_folder \
	  folder_id name label description parent_id mount_point

  db_transaction {
      db_exec_plsql rename_folder {}
  }

  ad_returnredirect [export_vars -base ../$mount_point/index {folder_id}]

}

