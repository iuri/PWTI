ad_page_contract {

    Create a new folder under the current folder

} {
    {folder_id:optional,integer }
    {mount_point "sitemap"}
}

permission::require_permission -party_id [auth::require_login] \
    -object_id $folder_id -privilege write

set path [content::item::get_path -item_id $folder_id]
if {[template::util::is_nil path]} {
    set path "/"
}

ad_form -name add_folder -form {

    {new_folder_id:key}

    {parent_id:integer(hidden)
	{value $folder_id}
    }

    {folder_id:integer(hidden)
	{value $folder_id}
    }

    {mount_point:text(hidden)
	{value $mount_point}
    }

    {path:text(inform)
	{label "Create in"}
	{value $path}
    }

    {name:text(text)
	{label "Name"}
	{help_text "Short name containing no special characters"}
    }

    {label:text(text),optional
	{label "Label"}
	{html {size 30}}
	{help_text "More descriptive label"}
    }

    {description:text(textarea),optional
	{label "Description"}
	{html {rows 5 cols 40 wrap physical}}
    }

} -validate {

    {name
	{ ![ string match "*/*" $name ] }
	{ Folder name cannot contain slashes }
    }

} -on_submit {

    set folder_id [content::folder::new -folder_id $new_folder_id -name $name -label $label \
		       -description $description -parent_id $parent_id]
    if { [string equal $mount_point "templates"] } {
	content::folder::register_content_type -folder_id $folder_id \
	    -content_type content_template
    }

} -after_submit {

    ad_returnredirect [export_vars -base index {folder_id mount_point parent_id}]

}
