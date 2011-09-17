ad_page_contract {


  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23
} {
	account_id
	query_id:optional
}

permission::require_permission -party_id [ad_conn user_id] -object_id $account_id -privilege admin

ad_form -name query -export {account_id} -form {
	{query_id:key}
	{query_text:text {label "#mores.query_name#"}}
	{isactive:text(radio) {options {{"Ativa" t} {"Inativa" f}}}  {label "Ativa ou Invativa?"}}
} -select_query_name get_data_info -on_submit {
# set x [mores::query_new  -account_id $account_id -query_text $query_text    -isactive 1]
} -new_data { 
	mores::query_new -account_id $account_id -query_text $query_text -isactive 1
} -edit_data {
	mores::query_edit -query_id $query_id -query_text $query_text
	mores::query_change_state -query_id $query_id -isactive $isactive
} -after_submit {
	ad_returnredirect "query?account_id=$account_id"
    ad_script_abort
}




	
