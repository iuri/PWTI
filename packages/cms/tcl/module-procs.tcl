######################################################
#
# Procedures to generate and maintain the browser's tree
#
# Each module resides in its own namespace, and implements 
# the following 3 procs:
#
# getChildFolders { id } - returns the child folders of a given
#    folder
# getSortedPaths { name id_list {root_id 0} {eval_code {}}} - sets the name to be a multirow
#  datasource listing all paths in sorted order
#  The datasource must contain 3 columns: item_id, item_path and item_type
#
# The folder data structure is a list of the form
#
# { mount_point name id {} expandable_p symlink_p }
#
#####################################################
 

namespace eval cm {
    namespace eval modules {     
        namespace eval workspace  { }
        namespace eval templates  { }
        namespace eval workflow   { }
        namespace eval sitemap    { }
        namespace eval types      { }
        namespace eval search     { }
        namespace eval categories { }
        namespace eval users      { }
        namespace eval clipboard  { }
        namespace eval install  { }
    }
}


ad_proc -public cm::modules::get_module_id { 
    -module_name:required
    -package_id:required
} {

 Get the id of some module, return empty string on failure

} {
    return [db_string module_get_id ""]
}

ad_proc -public cm::modules::getMountPoints {} {

  Get a list of all the mount points

} {
    set mount_point_list [db_list_of_lists get_list ""]
    
    # Append clipboard
    lappend mount_point_list [folderCreate "clipboard" "Clipboard" "" [list] t f 0]

    return $mount_point_list
}

ad_proc -public cm::modules::getChildFolders { mount_point id } {

  Generic getCHildFolders procedure for sitemap and templates

} {

    # query for child site nodes
    set module_name [namespace tail [namespace current]]

    set result [db_list_of_lists module_get_result ""]

    return $result
}

ad_proc -public cm::modules::workspace::getRootFolderID { package_id } { return 0 } 

ad_proc -public cm::modules::workspace::getChildFolders { id } {
    return [list]
}



ad_proc -public cm::modules::templates::getRootFolderID { package_id } {

  Retreive the id of the root folder

} {
    if { ![nsv_exists browser_state template_root_$package_id] } {
        set root_id [db_string template_get_root_id ""]
        nsv_set browser_state template_root_$package_id $root_id
        return $root_id
    } else {
        return [nsv_get browser_state template_root_$package_id]
    }
}

ad_proc -public cm::modules::templates::getChildFolders { id } {


} {
    if { [string equal $id {}] } {
        set id [getRootFolderID [ad_conn package_id]]
    }

    # query for child site nodes
    set module_name [namespace tail [namespace current]]

    return [cm::modules::getChildFolders $module_name $id]
}

ad_proc -public cm::modules::templates::getSortedPaths { name id_list {root_id 0} {eval_code {}}} {


} {
    uplevel "
          cm::modules::sitemap::getSortedPaths $name \{$id_list\} $root_id \{$eval_code\}
        "
}

ad_proc -public cm::modules::workflow::getRootFolderID {} { return 0 } 

ad_proc -public cm::modules::workflow::getChildFolders { id } {
    return [list]
}



ad_proc -public cm::modules::sitemap::getRootFolderID { package_id } {

  Retreive the id of the root folder

} {
    if { ![nsv_exists browser_state sitemap_root_$package_id] } {
        set root_id [db_string sitemap_get_root_id ""]
        nsv_set browser_state sitemap_root_$package_id $root_id
        return $root_id
    } else {
        return [nsv_get browser_state sitemap_root_$package_id]
    }
}

ad_proc -public cm::modules::sitemap::getChildFolders { id } {


} {
    if { [string equal $id {}] } {
        set id [getRootFolderID [ad_conn package_id]]
    }

    # query for child site nodes
    set module_name [namespace tail [namespace current]]
    
    return [cm::modules::getChildFolders $module_name $id]
}

ad_proc -public cm::modules::sitemap::getSortedPaths { name id_list {root_id 0} {eval_code {}}} {


} {

    set sql_id_list "'"
    append sql_id_list [join $id_list "','"]
    append sql_id_list "'"

    upvar sorted_paths_root_id _root_id
    set _root_id $root_id
    set sql [db_map sitemap_get_name]
    uplevel "db_multirow $name sitemap_get_name \{$sql\} { $eval_code }"
} 




ad_proc -public cm::modules::types::getTypesTree { } {

  Return a multilist representing the types tree,
  for use in a select widget

} {

    set result [db_list_of_lists types_get_result ""]

    set result [concat [list [list "--" ""]] $result]

    return $result
}

ad_proc -public cm::modules::types::getRootFolderID { package_id } { return "content_revision" } 

ad_proc -public cm::modules::types::getChildFolders { id } {


} {

    set children [list]

    if { [string equal $id {}] } {
        set id [getRootFolderID [ad_conn package_id]]
    }

    # query for message categories
    set module_name [namespace tail [namespace current]]

    set result [db_list_of_lists get_result ""]

    return $result
}

# end of types namespace

ad_proc -public cm::modules::search::getRootFolderID { package_id } { return 0 } 

ad_proc -public cm::modules::search::getChildFolders { id } {
    return [list]
}


ad_proc -public cm::modules::categories::getRootFolderID { package_id } { return 0 } 

ad_proc -public cm::modules::categories::getChildFolders { id } {


} {

    set children [list]

    if { [string equal $id {}] } {
        set where_clause "k.parent_id is null"
    } else {
        set where_clause "k.parent_id = :id"
    }

    set module_name [namespace tail [namespace current]]

    # query for keyword categories

    set children [db_list_of_lists category_get_children ""]

    return $children
}

ad_proc -public cm::modules::categories::getSortedPaths { name id_list {root_id 0} {eval_code {}}} {


} {

    set sql_id_list "'"
    append sql_id_list [join $id_list "','"]
    append sql_id_list "'"

    set sql  [db_map get_paths]
    uplevel "db_multirow $name get_paths \{$sql\} \{$eval_code\}"
}


# end of categories namespace

ad_proc -public cm::modules::users::getRootFolderID {} { return 0 }  

ad_proc -public cm::modules::users::getChildFolders { id } {


} {
    
    if { [string equal $id {}] } {
        set where_clause "not exists (select 1 from group_component_map m
                                          where m.component_id = g.group_id)"
        set map_table ""
    } else {
        set where_clause "m.group_id = :id and m.component_id = g.group_id"
        set map_table ", group_component_map m"
    }

    set module_name [namespace tail [namespace current]]


    set result [db_list_of_lists users_get_result ""]

    return $result
}

ad_proc -public cm::modules::users::getSortedPaths { name id_list {root_id 0} {eval_code {}}} {


} {

    set sql_id_list "'"
    append sql_id_list [join $id_list "','"]
    append sql_id_list "'"

    set sql [db_map users_get_paths]
    
    uplevel "db_multirow $name users_get_paths \{$sql\} \{$eval_code\}"
}



ad_proc -public cm::modules::clipboard::getRootFolderID { package_id } { return 0 } 

ad_proc -public cm::modules::clipboard::getChildFolders { id } {


} {

    # Only the mount point is expandable
    if { ![template::util::is_nil id] } {
        return [list]
    }

    set children [list]
    
    set module_name [namespace tail [namespace current]] 

    set result [db_list_of_lists clip_get_result ""]

    return $result
}

# end of clipboard namespace

ad_proc -private cm::modules::install::create_modules { 
    -package_id:required
} {

    Create modules for a new CMS instance

} {
    set instance_name [apm_instance_name_from_id $package_id]
    set modules [list Sitemap Templates Types Categories Search]
    set sort_key 0
    set root_key ""
    foreach module $modules {
	incr sort_key
	set module_name "$instance_name $module"
	switch $module { 
	    "Sitemap" {
		set root_key [content::folder::new -name pkg_${package_id}_content \
				  -context_id $package_id \
				  -parent_id "-100" \
				  -label "$instance_name $module" ]
	    }
	    "Templates" {
		set root_key [content::folder::new -name pkg_${package_id}_templates \
				  -context_id $package_id \
				  -parent_id "-200" \
				  -label "$instance_name $module" ]
	    }
	    "Types" {
		set root_key content_revision
	    }
	    "Categories" {
		set root_key 0
	    }
	}
	set module_id [db_exec_plsql create_module {}]
	# assign context_id of package_id
	db_dml update_module_context {}
    }
}

ad_proc -private cm::modules::install::delete_modules { 
    -package_id:required
} {
    
    Delete modules for a given CMS instance

} {

    db_foreach get_module_ids {
	db_exec_plsql delete_module {}
    }

}