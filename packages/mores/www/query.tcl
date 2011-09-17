ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2011-02-05

} {
	account_id
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id 	$account_id -privilege admin]
set action_list ""

if {$admin_p eq 1} {
	set action_list "\"#mores.New-query#\" \"query-ae?account_id=$account_id\" \"#mores.New-query#\" \"#mores.account_view#\" \"account?account_id=$account_id\" \"#mores.account_view#\""
}


template::list::create -name query_list -multirow query_list -key query_id -actions $action_list -pass_properties {
} -elements {
    name {
        label "Termo"
        display_template {
	        @query_list.query_text@
	    }
    }
    isactive {
        label "Ativa?"
        display_template {
	        @query_list.isactive@
	    }
    }
  	actions {
        label "Ações"
        display_template {
   				<a href="query-del?query_id=@query_list.query_id@&account_id=$account_id">
			  		Delete
				</a> |  
			    <a href="query-ae?query_id=@query_list.query_id@&account_id=$account_id">
					Edit
				</a>
	       }
    }
}

db_multirow  query_list  select_query {
    SELECT query_id, query_text, isactive
    FROM mores_acc_query
    WHERE account_id = :account_id
    AND deleted_p = 'f';
} {
		set admin_p $admin_p	
		if {$isactive == "t"} {
			set isactive "Ativada"
		} else {
			set isactive "Desativada"
		}
	}
	

