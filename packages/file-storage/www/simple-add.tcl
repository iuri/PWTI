ad_page_contract {
    page to add a new nonversioned object to the system

    @author Ben Adida (ben@openforce.net)    
    @author arjun (arjun@openforce.net)
    @creation-date 01 April 2002
    @cvs-id $Id: simple-add.tcl,v 1.11 2005/05/26 08:28:46 maltes Exp $
} {
    folder_id:integer,notnull
    {type "fs_url"}
    {title ""}
    {lock_title_p 0}
} -validate {
    valid_folder -requires {folder_id:integer} {
	if ![fs_folder_p $folder_id] {
	    ad_complain "[_ file-storage.lt_The_specified_parent_]"
	}
    }
} -properties {
    folder_id:onevalue
    context:onevalue
}

# check for write permission on the folder

ad_require_permission $folder_id write

# set templating datasources

set pretty_name "URL"
if {[empty_string_p $pretty_name]} {
    return -code error "[_ file-storage.No_such_type]"
}

set context [fs_context_bar_list -final [_ file-storage.Add_pretty_name [list pretty_name $pretty_name]] $folder_id]

# Should probably generate the item_id and version_id now for
# double-click protection

# if title isn't passed in ignore lock_title_p
if {[empty_string_p $title]} {
    set lock_title_p 0
}

# Message lookup uses variable pretty_name
set page_title [_ file-storage.simple_add_page_title]


ad_form -action simple-add-2 -export {folder_id type} -form {
    {dummy:text(hidden)}
} -has_submit 1

if {$lock_title_p} {
    ad_form -extend -form {
        {title_display:text(inform) {label \#file-storage.Title\#} }
        {title:text(hidden) {value $title}}
    }
} else {
    ad_form -extend -form {
        {title:text {label \#file-storage.Title\#} {html {size 30}} }
    }
}

set submit_label [_ file-storage.Create]

ad_form -extend -form {
    {url:text(text) {label \#file-storage.URL\#} {value "http://"}}
    {description:text(textarea),optional {html {rows 5 cols 50}} {label \#file-storage.Description\#}}
    {submit:text(submit) {label $submit_label}}
}
