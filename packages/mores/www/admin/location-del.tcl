ad_page_contract {
  Delete one data-aggregator 

  @author Alessandro Landim
} {
	territory_location_id
}

permission::require_permission -party_id [ad_conn user_id] -object_id $territory_location_id -privilege admin

ad_form -export {territory_location_id} -name locations -form {
	{option:text(radio) {options {{"#action-manager.Yes#" 1} {"#action-manager.No#" 0}}}  {label "#action-manager.Choose_Option_to_delete#"}}
} -on_submit {

	if {$option eq 1} {
		am::location::del -territory_location_id $territory_location_id
	}
	
	ad_returnredirect "."

} 




	
