if {![info exists ds_name]} {set ds_name ""}

set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin] 

if {$admin_p && $customize_p} {
		set customize 1
}

set return_url [ad_return_url]
