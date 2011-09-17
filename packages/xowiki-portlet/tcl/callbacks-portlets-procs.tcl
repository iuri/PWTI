ad_library {
    Xowiki portlets Callback definitions

    @author Alessandro Landim <alessandro.landim@gmail.com>
    @creation-date 2009-05-07
}

ad_proc -public -callback add_portlet_to_page  -impl xowiki {
    portlet_name
	portal_id
	args
} {
    Add application portlet in portal_id
} {
	 if {$portlet_name == "xowiki_portlet"} {
		#the xowiki portlet doesn't work
		return
	 }

	  ${portlet_name}::add_self_to_page \
	  -portal_id $portal_id \
	  -package_id [ns_set get $args "package_id"] 
}
