ad_page_contract {


  @author Breno Assuncao (assuncao.b@gmail.com

} {
 account_id
}
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""

set context [list [list "." Linguas] Locais]


template::list::create -name lang_list -multirow lang_list -key lang -actions $action_list -pass_properties {
} -elements {
    lang {
        label "Usuario"
        display_template {
	        @lang_list.lang@
	    }
    }
    status {
        label "Estado"    
    }
   	actions {
        label "Ações"
        display_template {
	        <a class="button" href="lang_block-ajax?lang=@lang_list.lang@&account_id=$account_id">
				Bloquear
			</a> | 
			<a class="button" href="lang-unblock?lang=@lang_list.lang@&account_id=$account_id">
				Desbloquear
			</a>  
        }
    }
}

set export_vars "account_id=$account_id"


db_multirow  lang_list  select_lang_block {
	SELECT distinct ms.lang, COALESCE (ml.id, 0) as status
	FROM mores_stat_source_query ms
	left join (select 1 as id, lang, account_id from mores_lang_acc_block) ml
		on (ms.lang = ml.lang and ms.account_id = ml.account_id)
	where ms.account_id = :account_id;
} {

	if {$status == 1} {
		set status "BLOQUEADO"
	} else {
		set status "OK"	
	}
set admin_p $admin_p
}
