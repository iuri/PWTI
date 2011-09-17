ad_page_contract {
} {
	{attribute_id:optional}
	{report_id:optional}
}

permission::require_permission -object_id [ad_conn package_id] -privilege admin
reports::attributes::del -attribute_id $attribute_id

ad_returnredirect -message "[_ reports.Attribute_deleted]" "show-report?report_id=$report_id"

