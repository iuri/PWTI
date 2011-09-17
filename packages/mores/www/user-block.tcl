ad_page_contract {
  List data aggregator for this package_id 

  @author Breno Assuncao (assuncao.b@gmail.com

} {
 account_id
}
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""

set context [list [list "." Usuarios] Locais]


template::list::create -name user_list -multirow user_list -key user_nick -actions $action_list -pass_properties {
} -elements {
    user_nick {
        label "Usuario"
        display_template {
	        @user_list.user_nick@
	    }
    }
    source {
        label "Rede"
        display_template {
	        @user_list.source@
	    }
    }
    query_text {
        label "Termo"
        display_template {
	        @user_list.query_text@
	    }
    }
	actions {
        label "Ações"
        display_template {
	        <a class="button" href="user-unblock?user_nick=@user_list.user_nick@&query_id=@user_list.query_id@&source=@user_list.source@&account_id=$account_id">
				Desbloquear
			</a> 
        }
    }
}

set export_vars "account_id=$account_id&sentimento=0"


db_multirow  user_list  select_user_block {
   SELECT maq.query_text, maq.query_id, user_nick, source
  FROM mores_user_block  mub, mores_acc_query maq
	WHERE maq.query_id = mub.query_id and maq.account_id = :account_id;
} {
set admin_p $admin_p
}
