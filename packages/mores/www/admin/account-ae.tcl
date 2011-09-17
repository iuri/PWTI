ad_page_contract {


  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23
} {
	account_id:optional
}
set package_id [ad_conn package_id]
permission::require_permission -party_id [ad_conn user_id] -object_id $package_id -privilege admin

set extra_css ""
set extra_css [parameter::get -parameter "aditional_css" -package_id $package_id]

ad_form -name account -form {
	{account_id:key}
	{name:text {label "Nome"}}
	{description:text(textarea) {label "Descrição"}}
{num_querys:text {label "Quantidade de termos"}}
	
} -select_query_name get_data_info -on_submit {
} -new_data { 
	mores::account_new -name $name -description $description -num_querys $num_querys
} -edit_data {
	mores::account_edit -account_id $account_id -name $name -description $description -num_querys $num_querys
} -after_submit {
	ad_returnredirect "."
    ad_script_abort
}




	
