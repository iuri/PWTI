ad_page_contract {

    Simple get children with ajax

    @author alessandro.landim@gmail.com
    @creation-date 2007-11-28
} {
    category_id:integer
}

if {[info exists category_id]} {
	set goal_type [category::get_name [category::get_mapped_categories $category_id]]
	set category_goal_type ""
	switch $goal_type {
		"Fluxo" {
			set category_goal_type 1
		} 
		"Etapa" {
			set category_goal_type 0
		}
	}
		append result "$category_goal_type"
} else {
	set result ""
}

set result [string trimright $result " "]
