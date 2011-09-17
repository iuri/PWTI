
# Criam os territórios dentro do pacote

db_foreach select_territories {SELECT sdt_code, territory_name, state_code, region, community_id, category_id
  FROM br_territories} {
  set territory_location_id [am::location::new -name $territory_name -sdt_code $sdt_code -uf_code $state_code -ibge_code [db_null] ]
  
  set location_territory($sdt_code) $territory_location_id
  }
  
      
set periods "2008 2009 20092 2010 20102"

set periods "2008 2009 2010"
foreach one_period $periods {

	set mtx_id [am::matrix::new -name $one_period -description "Matriz de Ações do Governo Federal" \
    -is_open_plan 0 -is_open_debate 0 \
    -is_open_exec 1 -parent_id 0 ]

	db_foreach selec_actions {SELECT initial_response_id, initial_user_id, action_name, response_id, 
		   eixo, gestor_action, coord_action, type_action, para_quem, para_quem_gen_ger, 
		   cod_programa_ppa, action_ppa, para_que_serve, quem_executa, unidades_executora, 
		   com_quem_executa, como_a_prioridade, papel_colegiado_def_prioridade, 
		   papel_colegiado_cont_social, unidade_meta_fisica, ano_orcamentario, 
		   meta_fisica_60, meta_financeira_60, period, archive_p, acesso_recurso, 
		   url, tipo_papel_colegiado, email_coordenador, setor_coordenador, 
		   modify_date
	  FROM br_territory_actions
	  where period = :one_period} {
  
  			set action_id_last_year [db_null] 
			set parent_id $initial_response_id 
			if {$period == 2009  || $period == 20092} {
				set action_id_last_year [db_string get_last_year {select  sqr.number_answer as response_ano_anterior
						FROM survey_question_responses sqr, br_territory_actions a
						WHERE a.period = 2009
							and sqr.response_id  = a.response_id
							and sqr.question_id = 1292061
							and a.initial_response_id =  :initial_response_id } -default ""]
			} 
			if {$period == 2010 || $period == 20102} {
				set action_id_last_year [db_string get_last_year {select  sqr.number_answer as response_ano_anterior
						FROM survey_question_responses sqr, br_territory_actions a
						WHERE a.period = 2010
							and sqr.response_id  = a.response_id
							and sqr.question_id = 3117446
							and a.initial_response_id =  :initial_response_id } -default ""]
			} 
		ns_log notice "$archive_p"
			set action_id [am::actions::new_temp -name $action_name -description $para_que_serve \
				-unit_goal $unidade_meta_fisica -territory_matrix_id $mtx_id \
				-active $archive_p  \
				-parent_id $parent_id  -action_id_last_year $action_id_last_year \
				-user_assign $initial_user_id \
				-eixo $eixo -theme $type_action -para_quem $para_quem \
				 -para_quem_gen_ger $para_quem_gen_ger -orgao $quem_executa \
				 -unidade_executora $unidades_executora \
				 -com_quem_executa $com_quem_executa \
				 -como_a_prioridade $como_a_prioridade \
				 -papel_colegiado_def_prioridade $papel_colegiado_def_prioridade \
				 -papel_colegiado_cont_social $papel_colegiado_cont_social \
				 -ano_orcamentario $ano_orcamentario \
				 -acesso_recurso $acesso_recurso -url $url \
				 -tipo_papel_colegiado $tipo_papel_colegiado \
				 -coord_action $coord_action \
				 -email_coordenador $email_coordenador \
				 -setor_coordenador $setor_coordenador \
				 -modify_date $modify_date ]
				 
			 db_foreach select_goals { SELECT initial_response_id, territory_sdt_code, goal, financial_goal, 
					  		 period, comentario, modify_date
				 		 FROM br_territory_action_goals
				 		 where period = :one_period				 
			  } {
			  		am::actions::new_goal -territory_action_id $action_id  \
						 -territory_location_id $location_territory($sdt_code)  -goal $goal \
						 -financial_goal $financial_goal  -comment $comentario \
						 -territory_matrix_id $mtx_id 				  
			  }]
			  # db for each goals

		}
		# db_foreach actions


}
#foreach periods
