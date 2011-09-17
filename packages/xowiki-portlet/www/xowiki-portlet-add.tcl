### includelet to add news portlet in portal_id

### this show all portlet this aplication have.



::xowiki::Package initialize -package_id $package_id


### includelet to add news portlet in portal_id

### this show all portlet this aplication have.

set options ""

db_foreach instance_select \
	      [::xowiki::Page instance_select_query \
		   -folder_id [::$package_id folder_id] \
		   -with_subtypes true \
		   -from_clause ", xowiki_page P" \
		   -where_clause "P.page_id = cr.revision_id" \
		   -orderby "ci.name" \
		  ] {
		    if {[regexp {^::[0-9]} $name]} continue
		    if {[info exists used_page_id($name)]} continue
		    lappend options "$name $name"
		  }




ad_form -name add_portlet -export {portal_id package_id return_url application_key} -form {
	{page_name:text(radio) {options $options}}
	{internacionalization:text(radio) {options {{#xowiki.Yes# 1} {#xowiki.No# 0}}}}
} -on_submit {
	

	set page_id [$package_id resolve_request -path $page_name method]
	set page_id [::Generic::CrItem lookup -name $page_name -parent_id [$package_id folder_id]]
	set page_title [$page_id title]

	set element_id [portal::add_element \
                        -portal_id $portal_id \
                        -portlet_name [xowiki_portlet::get_my_name] \
                        -pretty_name $page_title \
                        -force_region [parameter::get_from_package_key \
                                           -parameter "xowiki_portal_content_force_region" \
                                           -package_key "xowiki-portlet"]
                   ]

    portal::set_element_param $element_id package_id $package_id
	
    if {$internacionalization == 1} {	
	    portal::set_element_param $element_id page_name [lindex [split [$page_id name] "::"] 1]
	} else {
	    portal::set_element_param $element_id page_name [$page_id name]
	}

} -after_submit {
	ad_returnredirect $return_url
}

