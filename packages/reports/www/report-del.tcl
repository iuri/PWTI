ad_page_contract {
} {
	{report_id:optional}
}

permission::require_permission -object_id [ad_conn package_id] -privilege admin
reports::del -report_id $report_id 
ad_returnredirect -message "[_ reports.Report_deleted]" .

