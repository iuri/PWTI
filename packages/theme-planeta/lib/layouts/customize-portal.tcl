
set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]
set return_url [ad_return_url]
set customize_p [portal::customize_p -portal_id $portal_id]



if {$admin_p} {
	ah::requires -sources prototype
	ah::requires -sources "jquery"
	template::head::add_javascript -src "/resources/theme-mda/js/interface.js" -order 2
	template::head::add_css -href "/resources/theme-mda/css/interface.css"
}


if {$customize_p} {
	template::multirow create hidden_elements_list element_id element_name 
	foreach element_list [portal::hidden_elements_list_not_cached -portal_id $portal_id] {
		util_unlist $element_list element_id element_name
		template::multirow append hidden_elements_list $element_id $element_name
	}


	template::multirow create layouts_list layout_id name image
	foreach layout_list [portal::layouts] {
		util_unlist $layout_list element_id name
		set name_splited [split $name .]
		### get theme zen layouts. Only!
		if {[lsearch $name_splited "#theme-mda"] != -1} {
			util_unlist $layout_list layout_id name
			set layout_image [string trim [lindex $name_splited 1] "#"]
			template::multirow append  layouts_list $layout_id $name $layout_image
		}
	}
}


