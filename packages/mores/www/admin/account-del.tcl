ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23
} {
	account_id
}

set package_id [ad_conn package_id]
set extra_css ""
set extra_css [parameter::get -parameter "aditional_css" -package_id $package_id]

permission::require_permission -party_id [ad_conn user_id] -object_id $account_id -privilege admin

ad_form -export {account_id} -name matrix -form {
	{option:text(radio) {options {{"Sim" 1} {"Não" 0}}}  {label "Tem certeza que deseja deletar esta conta. Esta operação não pode ser desfeita."}}
} -on_submit {

	if {$option eq 1} {
		mores::account_del -account_id $account_id
	}
	
	ad_returnredirect "."

} 




	
