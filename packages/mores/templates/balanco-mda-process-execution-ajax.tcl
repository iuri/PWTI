ad_page_contract {
    
process goals for MDA execution
	
    @creation-date 2010-08-27
    @author Breno Assunção assuncao.b@gmail.com
} {
    {territory_action_id_p}
    {territory_matrix_id_p}
    {territory_step_id_p}
    {step_name}
    {financeiro:array ""}
    {fisico:array ""}    
} 
set package_id 	  [ad_conn package_id]


set list_of_matrix [db_list  select_matrix {
	   select territory_matrix_id
		FROM am_matrix
		where   package_id = :package_id	
		order by name} ]

set list_of_locations [db_list_of_lists  select_location {
	   select territory_location_id, name
		FROM am_territory_location
		where   package_id = :package_id	
		order by name} ]

set  action_name [db_string get_action_name {
	   SELECT name
	   FROM am_territory_action
	   where territory_action_id = :territory_action_id_p
	  		and territory_matrix_id = :territory_matrix_id_p;} -default ""]


foreach territory_matrix_id $list_of_matrix {
ns_log notice "matriz $territory_matrix_id"
	set territory_action_id [db_string  select_action {
		    select territory_action_id
			FROM am_territory_action
			where  territory_matrix_id = :territory_matrix_id
				and name = :action_name	
			order by name} ]
			
	set territory_control_point_id [db_string  select_control_point {
		    select territory_control_point_id
			FROM am_territory_control_point
			where  territory_matrix_id = :territory_matrix_id} ]
	if {$step_name != "Financeiro"} {
				ns_log notice "nao 'e Financeiro"
		set list_of_variables [db_list_of_lists  select_variables {
			select ats.territory_step_id, ats2.territory_step_id
				FROM am_territory_step ats, am_territory_step ats2
				where ats.territory_matrix_id = :territory_matrix_id_p
					and ats.territory_action_id = :territory_action_id_p
					and ats.territory_step_id = :territory_step_id_p
					and ats2.territory_action_id = :territory_action_id
					and ats.name = ats2.name
				order by ats.sort_order} ]
	} else {
				ns_log notice "'e Financeiro sim"
	
	}		
	foreach territory_location $list_of_locations {
	    util_unlist $territory_location territory_location_id location_name
		if {$step_name == "Financeiro"} {
			ns_log notice "'e Financeiro"
			set paid $financeiro($territory_matrix_id.$location_name)
			set  territory_execution_id  [db_string get_execution_id {
					   SELECT territory_execution_id
					   FROM am_territory_execution
					   where territory_action_id = :territory_action_id
					  		and territory_matrix_id = :territory_matrix_id
					  		and territory_location_id = :territory_location_id
					  		and territory_control_point_id = :territory_control_point_id;} -default ""]
			if {$territory_execution_id == ""} {
			ns_log notice "nao tem execucao"
				set territory_execution_id [am::execution::new -territory_matrix_id $territory_matrix_id \
						-territory_action_id $territory_action_id \
						-territory_location_id $territory_location_id \
						-territory_control_point_id $territory_control_point_id \
						-paid $paid] 
		
			} else {
				ns_log notice "tem execucao"
				am::execution::edit -territory_execution_id $territory_execution_id -paid $paid	
			}		
		} else {
		ns_log notice "eh fisico"
			## caso seja uma execução física
			set  territory_execution_id  [db_string get_execution_id {
				   SELECT territory_execution_id
				   FROM am_territory_execution
				   where territory_action_id = :territory_action_id
				  		and territory_matrix_id = :territory_matrix_id
				  		and territory_location_id = :territory_location_id
				  		and territory_control_point_id = :territory_control_point_id;} -default ""]
			if {$territory_execution_id == ""} {
			ns_log notice "nao tem execucao"
				set territory_execution_id [am::execution::new -territory_matrix_id $territory_matrix_id \
						-territory_action_id $territory_action_id \
						-territory_location_id $territory_location_id \
						-territory_control_point_id $territory_control_point_id \
						-paid -1] 
			
				foreach variables $list_of_variables {
					util_unlist $variables 	territory_step_id territory_step_id_real
					set executed $fisico($territory_matrix_id.$location_name.$territory_step_id)
				
					am::execution::step_new -territory_execution_id $territory_execution_id \
						-territory_step_id $territory_step_id_real -executed $executed
				}
		
			}  else {
				foreach variables $list_of_variables {
					util_unlist $variables 	territory_step_id territory_step_id_real
					set executed $fisico($territory_matrix_id.$location_name.$territory_step_id)				
					am::execution::step_edit -territory_execution_id $territory_execution_id \
	   						-territory_step_id $territory_step_id_real -executed $executed 
				}		
			}
		
		
		}
		

	}
}


set result_msg "As informações foram salvas com sucesso!!."
ns_return 200 "text/html; charset=utf-8" $result_msg
