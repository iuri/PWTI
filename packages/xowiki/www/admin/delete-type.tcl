::xowiki::Package initialize -ad_doc {
  This deletes a type with all subtypes and instances

  @author Gustaf Neumann (gustaf.neumann@wu-wien.ac.at)
  @creation-date Aug 11, 2006
  @cvs-id $Id: delete-type.tcl,v 1.9.4.1 2008/12/12 13:49:07 gustafn Exp $

  @param object_type 
  @param query
} -parameter {
  {-object_type ::xowiki::Page}
  {-return_url "."}
}

set sql [$object_type instance_select_query -with_subtypes 0 -folder_id [::$package_id folder_id]]
db_foreach retrieve_instances $sql {
  permission::require_write_permission -object_id $item_id
  $package_id delete -item_id $item_id -name $name
}

# drop type requires that all pages of all xowiki instances are deleted
# foreach type [$object_type object_types -subtypes_first true] {$type drop_object_type}

ad_returnredirect $return_url
