ad_page_contract {
  This is a form to upload video 

  @author Alessandro Landim

  $Id: site-master.tcl,v 1.22.2.7 2007/07/18 10:44:06 emmar Exp $
} {
	territory_location_id:optional
}

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin

ad_form -name location -form {
	{territory_location_id:key}
	{name:text {label "#action-manager.name#"}}
	{ibge_code:optional,text {label "#action-manager.ibge_code#"}}
	{sdt_code:optional,text {label "#action-manager.sdt_code#"}}
	{uf_code:optional,text {label "#action-manager.uf_code#"}}
} -select_query_name get_data_info -on_submit {
} -new_data {
	am::location::new -name $name -ibge_code $ibge_code -sdt_code $sdt_code -uf_code $uf_code
} -edit_data {
	am::location::edit -territory_location_id $territory_location_id -name $name -ibge_code $ibge_code -sdt_code $sdt_code -uf_code $uf_code
} -after_submit {
	ad_returnredirect "."
    ad_script_abort
}




	
