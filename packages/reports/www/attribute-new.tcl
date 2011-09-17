ad_page_contract {

	Form to create a new attribute	

} {
	{report_id:integer}
	{attribute_id:optional}
}

permission::require_permission -object_id [ad_conn package_id] -privilege admin

ad_form -name attribute-new -form {
	{attribute_id:key}
	{report_id:integer(hidden)
		{value $report_id}
	}
	{pretty_name:text}
	{attribute_type:text(radio) 
		{options {{#report.Filter# filter} {#report.Group# group} {#report.Data# data}}}
	}
	{value:text}
	{reference:text,optional}
} -on_submit {

} -edit_request {
	reports::attributes::get -attribute_id $attribute_id
	set report_id $attribute(report_id)
	set pretty_name $attribute(pretty_name)
	set attribute_type $attribute(type)
	set value $attribute(value)
	set reference $attribute(reference)
		
} -edit_data {
	reports::attributes::edit -attribute_id $attribute_id -report_id $report_id -type $attribute_type -value $value -pretty_name $pretty_name -reference $reference
} -new_data {
	reports::attributes::new -attribute_id $attribute_id -report_id $report_id -type $attribute_type -value $value -pretty_name $pretty_name -reference $reference
} -after_submit {
	ad_returnredirect "show-report?report_id=$report_id"
}
