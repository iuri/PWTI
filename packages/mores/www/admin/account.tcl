ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23

} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""

if {$admin_p eq 1} {
	set action_list {"#action-manager.New-matrix#" matrix-new "#action-manager.New-matrix#"}
}


template::list::create -name matrix_list -multirow matrix_list -key territory_matrix_id -actions $action_list -pass_properties {
} -elements {
    name {
        label "Nome"
        display_template {
	        @matrix_list.name@
	    }
    }
    description {
        label "Descrição"
        display_template {
	        @matrix_list.description@
	    }
    }
    is_open_plan {
        label "Planejamento"
        display_template {
	        @matrix_list.is_open_plan@
	    }
    }
    is_open_debate {
        label "Debates"
        display_template {
	        @matrix_list.is_open_debate@
	    }
    }
    is_open_exec {
        label "Execução"
        display_template {
	        @matrix_list.is_open_exec@
	    }
    }
	actions {
        label "Ações"
        display_template {

	        <a class="button" href="matrix-del?territory_matrix_id=@matrix_list.territory_matrix_id@">
				#action-manager.Delete_matrix#
			</a> 
	        <a class="button" href="matrix-new?territory_matrix_id=@matrix_list.territory_matrix_id@">
				#action-manager.Edit_matrix#
			</a>
	        <a class="button" href="action-new?territory_matrix_id=@matrix_list.territory_matrix_id@">
				#action-manager.Create_new_action#
			</a>



        }
    }
}

db_multirow  matrix_list  select_matrix {
   SELECT territory_matrix_id
   		,name
   		,description
   		,package_id
   		,is_open_plan
   		,is_open_debate
   		,is_open_exec
   		,parent_id
  	FROM am_matrix
	where   package_id = :package_id	
        and 't' = acs_permission__permission_p(territory_matrix_id, :user_id, 'read')
} {
	set admin_p $admin_p
	if {$is_open_plan == 1 } {
		set is_open_plan "Aberto"
	} else {
		set is_open_plan "Fechado"
	}
	
	if {$is_open_debate == 1 } {
		set is_open_debate "Aberto"
	} else {
		set is_open_debate "Fechado"
	}
	
	if {$is_open_exec == 1 } {
		set is_open_exec "Aberto"
	} else {
		set is_open_exec "Fechado"
	}
}
