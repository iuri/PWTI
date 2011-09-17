ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23
} {
    query_id
    account_id
}

#permission::require_permission -party_id [ad_conn user_id] -object_id $query_id -privilege admin

ad_form -export {query_id account_id} -name query -form {
    {option:text(radio) {options {{"Sim" 1} {"Não" 0}}}  {label "Tem certeza que deseja deletar esta Query. Todas as menções relacionadas serão deletadas e esta operação não pode ser desfeita."}}
} -on_submit {
    ns_log Notice "$query_id - $account_id"
    if {$option eq 1} {
	mores::query_del -query_id $query_id -account_id $account_id
    }
    
    ad_returnredirect "query?account_id=$account_id"
    ad_script_abort
} 




	
