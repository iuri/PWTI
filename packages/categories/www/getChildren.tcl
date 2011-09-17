ad_page_contract {

    Simple get children with ajax

    @author alessandro.landim@gmail.com
    @creation-date 2007-11-28
} {
    category_id:integer
}

if {[info exists category_id]} {
	set categories_children [category::get_children -category_id $category_id]
	set result ""
	 

	foreach category $categories_children {
		append result "[category::get_name $category [ad_conn locale]]|$category|"
	}
} else {
	set result ""
}

set result [string trimright $result " "]
