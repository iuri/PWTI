ad_page_contract {
} {
	{report_id:optional}
}

permission::require_permission -object_id [ad_conn package_id] -privilege admin

ad_form -name report-new -form {
	{report_id:key}
	{report_name:text}
	{table_name:text}
} -on_submit {
} -edit_request {
	reports::get -report_id $report_id
	set report_name $report(report_name)
	set table_name $report(table_name)
} -edit_data {
	reports::edit -report_id $report_id -report_name $report_name -table_name $table_name
} -new_data {
	reports::new -report_id $report_id -report_name $report_name -table_name $table_name
} -after_submit {
	ad_returnredirect -message "[_ reports.Report_created]" .
}

