if {![info exists ds_name]} {set ds_name ""}


switch $ds_name {
	calendar_portlet {set image appointment-new.png}
	calendar_list_portlet {set image office-calendar.png}
	dotlrn_main_portlet {set image system-users.png}
	news_portlet {set image internet-news-reader.png}
	chat_portlet {set image internet-group-chat.png}
	faq_portlet {set image help-browser.png}
	dotlrn_members_portlet {set image Address-Book-32x32.png}
	calendar_full_portlet {set image x-office-calendar.png}
	default {set image window-new.png} 
}

set customize 0
set customize_p [portal::customize_p -portal_id [portal::element_portal_id -element_id $element_id]]
set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin] 

if {$admin_p && $customize_p} {
		set customize 1
}

set return_url [ad_return_url]
