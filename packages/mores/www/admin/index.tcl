ad_page_contract {
    
    index file
    
    @author Breno Assunção (assuncao.b@gmail.com)
    @creation-date 2010-08-23
} {

}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""

set page_add [parameter::get -parameter "page-add"]
set extra_css ""
set extra_css [parameter::get -parameter "aditional_css" -package_id $package_id]

set qtd_accounts  [db_string select_accounts { SELECT count(*)
			  FROM mores_accounts
				where package_id = :package_id;
	   } -default "0"]

set initial_configuration "no"
	   

	set initial_configuration "ok"
	set action_list [list "Criar Conta" account-ae "Criar Conta"]

	if {$admin_p eq 1} {

		#lappend action_list "#mores.manager-accounts#" account-ae "#mores.manager-accounts#"

	}
	template::list::create -name account_list -multirow account_list -key account_id -actions $action_list -pass_properties {
	} -elements {
		name {
		    label "Nome"
		    display_template {
			    <a href="../account?account_id=@account_list.account_id@">@account_list.name@</a>
			}
		}
		description {
		    label "Descrição"
		    display_template {
			    @account_list.description@
			}
		}
		num_querys {
		    label "Quantidade de Termos"
		    display_template {
			    @account_list.num_querys@
			}
		}
		date {
		    label "Data de ativação"
		    display_template {
			    @account_list.date@
			}
		}
		actions {
		    label "Ações"
		    display_template {
			    <a href="account-del?account_id=@account_list.account_id@">
			  		Delete
				</a> |  
			    <a href="account-ae?account_id=@account_list.account_id@">
					Edit
				</a>

		    }
		}
	}

	db_multirow  account_list  select_account {
	   SELECT account_id
	   		,a.name
	   		,a.description
	   		,a.package_id
	   		,num_querys
	  	,to_char(o.creation_date, 'DD-MM-YYYY') as date
	  	FROM mores_accounts a, acs_objects o
		where   a.package_id = :package_id and a.account_id = o.object_id 		
		    and 't' = acs_permission__permission_p(account_id, :user_id, 'read')
	} {
		set admin_p $admin_p		
	}
	



