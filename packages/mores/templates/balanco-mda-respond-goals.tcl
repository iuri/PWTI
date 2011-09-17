ad_page_contract {
    
    index file
    
    @author Breno Assunção (assuncao.b@gmail.com)
    @creation-date 2010-08-23
} {
    {financeiro:array ""}
    {fisico:array ""}    
} 


permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set user_id [ad_conn user_id]
set package_id 	  [ad_conn package_id]

set territory_action_id_p $territory_action_id
set territory_matrix_id_p $territory_matrix_id


#####
## Load form
####


template::multirow create lista_matrix matrix_name territory_matrix_id
template::multirow create lista_variaveis name territory_step_id
template::multirow create lista_location location_name territory_location_id checked

template::multirow create lista_dados step_name location_name matrix_name executed territory_step_id territory_location_id territory_matrix_id
template::multirow create lista_dados_financeiros location_name paid matrix_name territory_location_id territory_matrix_id



db_multirow  variaveis_list  select_dados_fisico {		
SELECT step_name, 
	  location_name,
 	  matrix_name,
 	  step_id_real,
 	  data.territory_step_id ,
	  data.territory_location_id,
 	  data.territory_matrix_id,
	  executed 
from ( select	  
	  atl.name AS location_name,
 	  am.name AS matrix_name,
	  atl.territory_location_id,
 	  am.territory_matrix_id,
 	  ata.territory_action_id,
 	  ats.name AS step_name, 
	  ats.territory_step_id as step_id_real, 
	  ats2.territory_step_id
	FROM 
	  am_matrix am, 
	  am_territory_action action_p, 
  	  am_territory_action ata,
	  am_territory_location atl,
	  am_territory_step as ats2, 
	  am_territory_step ats
  	WHERE 
	  ata."name" = action_p."name" AND
	  ata.territory_matrix_id = am.territory_matrix_id AND
	  ats2.name = ats.name AND
	  ata.territory_matrix_id = ats.territory_matrix_id AND
	  ata.territory_action_id = ats.territory_action_id AND
	  action_p.territory_matrix_id = ats2.territory_matrix_id AND
	  action_p.territory_action_id = ats2.territory_action_id AND
	  action_p.territory_action_id = :territory_action_id_p 
	 ) data  
	left join (
	   select 
		ates.executed,
		ate.territory_action_id,
		ate.territory_matrix_id,
		ate.territory_execution_id,
		ate.territory_location_id,
		ates.territory_step_id
	   from
		am_territory_execution ate, 
		am_territory_execution_steps ates
		
	   where 		
		ate.territory_execution_id = ates.territory_execution_id 	  
	) goals on (	  
		goals.territory_action_id = data.territory_action_id AND
		goals.territory_matrix_id = data.territory_matrix_id AND
		goals.territory_step_id = data.step_id_real AND		  	  
		goals.territory_location_id = data.territory_location_id 	   	  
	)  
	
ORDER BY step_name, location_name, matrix_name
 } {
	template::multirow append lista_dados $step_name $location_name $matrix_name $executed $territory_step_id $territory_location_id $territory_matrix_id
	
}   

db_multirow get_responses select_financial_responses {
	SELECT paid, 
	  location_name,
 	  matrix_name,
	  data.territory_location_id,
 	  data.territory_matrix_id 
from ( select	  
	  atl.name AS location_name,
 	  am.name AS matrix_name,
	  atl.territory_location_id,
 	  am.territory_matrix_id,
 	  ata.territory_action_id
	FROM 
	  am_matrix am, 
	  am_territory_action action_p, 
  	  am_territory_action ata,
	  am_territory_location atl
  	WHERE 
	  ata."name" = action_p."name" AND
	  ata.territory_matrix_id = am.territory_matrix_id AND
	  action_p.territory_action_id = :territory_action_id_p 
	 ) data  
	left join (
	   select 
		ate.paid,
		ate.territory_action_id,
		ate.territory_matrix_id,
		ate.territory_execution_id,
		ate.territory_location_id
	   from
		am_territory_execution ate		
	   
	) goals on (	  
		goals.territory_action_id = data.territory_action_id AND
		goals.territory_matrix_id = data.territory_matrix_id AND
		goals.territory_location_id = data.territory_location_id 	   	  
	)  
	
ORDER BY location_name, matrix_name
	 
} {
	if {$paid > 0} {
	   	regsub {\+} [lc_monetary_currency $paid "BRR" "pt_BR"] {} paid
	} else {
		set paid ""
	}

    template::multirow append lista_dados_financeiros $location_name $paid $matrix_name $territory_location_id $territory_matrix_id
}
set  current_action [db_string get_rec_goal {
   SELECT name
  FROM am_territory_action
  where territory_action_id = :territory_action_id_p
  		and territory_matrix_id = :territory_matrix_id_p;
    } -default ""]



db_multirow  variaveis_list  select_variaveis {
	   SELECT 
	  ata.territory_action_id, 
	  ats.name,
	  ats.territory_step_id
	  
	FROM 
	  am_territory_action ata, 
	  am_territory_step ats
	WHERE 
	  ats.territory_action_id = ata.territory_action_id
	  and ata.territory_action_id = :territory_action_id
	 ORDER BY sort_order ;	

} {
	template::multirow append lista_variaveis $name $territory_step_id
	set step($name) $territory_step_id
	lappend steps $territory_step_id
	append script_close_steps "
						jQuery('#titleAction$territory_step_id').hide(1000);
						jQuery('#link_$territory_step_id').removeClass(\"respondido03\");				
					"
					
	append jquery_ready2 "
		  jQuery(document).ready(function() { 
			jQuery('#form_send_$territory_step_id').ajaxForm(function() {
	   		        jQuery('#form_$territory_step_id').ajaxSubmit({
					beforeSubmit: hideSubmit($territory_step_id),
					error: erro,
				    	success: function() { 
					             showResponse($territory_step_id); 
				    	}  //post-submit callback 
				});
			}); 
		   });\n
		"
}

append jquery_ready2 "
		  jQuery(document).ready(function() { 
			jQuery('#form_send_texto').ajaxForm(function() {
	   		        jQuery('#form_texto').ajaxSubmit({
					beforeSubmit: hideSubmit('texto'),
					error: erro,
				    	success: function() { 
					             showResponse('texto'); 
				    	}  //post-submit callback 
				});
			}); 
		   });\n
		"
append jquery_ready2 "
		  jQuery(document).ready(function() { 
			jQuery('#form_send_financeiro').ajaxForm(function() {
	   		        jQuery('#form_financeiro').ajaxSubmit({
					beforeSubmit: hideSubmit('Financeiro'),
					error: erro,
				    	success: function() { 
					             showResponse('Financeiro'); 
				    	}  //post-submit callback 
				});
			}); 
		   });\n
		"


db_multirow  location_list  select_locations {
   SELECT territory_location_id
   		,name
   		,package_id
   		,ibge_code
   		,sdt_code
   		,uf_code
  FROM am_territory_location
	where   package_id = :package_id	
	order by name

} {
	template::multirow append lista_location $name $territory_location_id 1
	append script2 "var $name = $territory_location_id;\n"
}


db_multirow  matrix_list  select_matrix {
   select territory_matrix_id
	   		,name
	   		,description
	   		,package_id
	   		,is_open_plan
	   		,is_open_debate
	   		,is_open_exec
	   		,parent_id
    FROM am_matrix
	where   package_id = :package_id	
	order by name
} {
	template::multirow append lista_matrix $name $territory_matrix_id

	if {$name < 2010} {
		append script2 "var mtx_$name = $territory_matrix_id;\n"
	} elseif {$name == "2010 (Jan-Jul)"} {
		append script2 "var mtx_2010 = $territory_matrix_id;\n"
	} else {
		append script2 "var mtx_20102 = $territory_matrix_id;\n"
	}
	
}
append script_navegacao "jQuery('#link_titleActionTexto').click(function(){
		jQuery('#titleActionTexto').show(1000);
		jQuery('#titleActionTexto').fadeIn(1000);

		jQuery('#titleActionFinanceiro').hide(1000);				

		jQuery('#link_titleActionTexto').addClass(\"respondido03\");
		jQuery('#link_financeiro').removeClass(\"respondido03\");
		$script_close_steps
			
});\n"

append script_navegacao "jQuery('#link_financeiro').click(function(){
		jQuery('#titleActionFinanceiro').show(1000);
		jQuery('#titleActionFinanceiro').fadeIn(1000);

		jQuery('#titleActionTexto').hide(1000);				

		jQuery('#link_financeiro').addClass(\"respondido03\");
		jQuery('#link_titleActionTexto').removeClass(\"respondido03\");
		$script_close_steps
			
});\n"


foreach step_id $steps {
	append script_navegacao "jQuery('#link_$step_id').click(function(){
		$script_close_steps
		jQuery('#titleAction$step_id').show(1000);
		jQuery('#titleAction$step_id').fadeIn(1000);

		jQuery('#titleActionTexto').hide(1000);	
		jQuery('#titleActionFinanceiro').hide(1000);							

		jQuery('#link_$step_id').addClass(\"respondido03\");
		jQuery('#link_titleActionTexto').removeClass(\"respondido03\");
		jQuery('#link_financeiro').removeClass(\"respondido03\");			
	});\n"
}
			
set jquery_ready "			

	function hideSubmit (id_box) {
		document.getElementById('btEnviarResposta'+ id_box).disabled = true;		
		document.getElementById('btEnviarResposta' + id_box).value = 'Salvando os dados, aguarde que este procedimento pode levar alguns segundos';
	} 
	
	function showResponse(id_box)  {

 		
 		jQuery('#titleAction' + id_box).fadeOut(1000);	
 		jQuery('#titleAction' + id_box).load('action-view-step?territory_action_id_p=$territory_action_id_p&territory_matrix_id_p=$territory_matrix_id_p&territory_step_id_p=' +id_box + '&step_name='+id_box );
		jQuery('#titleAction' + id_box).fadeIn(1000);
		jQuery('#titleAction' + id_box).show(1000);
		document.getElementById('btEnviarResposta' + id_box).disabled = false;
		document.getElementById('btEnviarResposta' + id_box).value = 'Enviar Dados';
 	}
 	function erro()  {
 		alert('Durante o processamento de seus dados algo inesperado aconteceu, por favor recarregue a página e confira os dados.');
 	}
	jQuery(document).ready(function() { 
		$script_navegacao
   });
"

#		 		jQuery('#titleAction' + id_box).addClass(\"respondido03\");
template::head::add_javascript -src "/resources/action-manager/action-manager.js" -order 2
template::head::add_javascript -script $script2 -order 1
template::head::add_javascript -script $jquery_ready -order 5
template::head::add_javascript -script $jquery_ready2 -order 5
template::head::add_javascript -src "/dotlrn/clubs/territriosrurais/gestodamatriz/survey/ajax/jquery.form.js" -order 2
template::head::add_javascript -src "/resources/theme-zen/js/jquery-1.2.3.min.js" -order 1

template::head::add_javascript -src "/dotlrn/clubs/territriosrurais/gestodamatriz/survey/ajax/ajax-survey.js" -order 5
template::head::add_css -href "/resources/theme-zen/css/territorio.css" 
#
# Emulate IE7 in IE8 for css and javascript. Motivation Jquery.
#
template::head::add_meta \
    -content "IE=EmulateIE7" \
    -http_equiv "X-UA-Compatible"





###
## Put all form in ad_form
###
template::multirow create location_list name territory_action_id goal_value financial_goal
set locations_list [db_list_of_lists get_list {SELECT name, territory_location_id FROM am_territory_location atl  where package_id = :package_id}]
foreach location_values $locations_list {
		util_unlist $location_values name location_id 
		lappend locations $name
		set locations_ids($name) $location_id
		template::multirow append location_list $name $location_id "" ""
}

ad_form -name execution   

set listnames [parameter::get -parameter "AmsList" -package_id $package_id]

foreach listname $listnames {
	ad_form -extend -name execution -form [ams::ad_form::elements -package_key "action-manager" -object_type "territory_action" -list_name  $listname]
}

ad_form -extend -name execution -on_request {

	foreach listname $listnames {
		set list_id [ams::list::get_list_id -package_key "action-manager" -object_type "territory_action" -list_name $listname]
		set elements [ams::elements -list_ids $list_id]
		
		foreach element $elements {	
			util_unlist $element element_id required section_heading attribute_name pretty_name widget html_options
			set $attribute_name ""
		 } 
	}
 
	foreach listname $listnames {
		 set amsvalues [ams::values -package_key "action-manager" -object_type "territory_action" -list_name $listname -object_id $territory_action_id_p]
		 foreach {nothing1 attribute_name atribute_pretty_name value} $amsvalues {
			set $attribute_name $value
		 } 
	}
 
 
} -edit_request {

}



foreach listname $listnames {
		set list_id [ams::list::get_list_id -package_key "action-manager" -object_type "territory_action" -list_name $listname]
		set elements [ams::elements -list_ids $list_id]
		
		foreach element $elements {	
	
			util_unlist $element element_id required section_heading attribute_name pretty_name widget html_options
			append ams_html "<div class=\"form-item-wrapper\">
			<div class=\"form-label\">
				<label for=\"$attribute_name\">$pretty_name</label>
					<div class=\"form-required-mark\">
					(*)
					</div>
			</div> <!-- /form-label or /form-error -->
			<div class=\"form-widget\">
			"
			switch $widget {
				textbox {append ams_html "<input type=\"text\" id=\"$attribute_name\" name=\"$attribute_name\" value=\"[set $attribute_name]\">"}
				textarea {append ams_html "<textarea id=\"$attribute_name\" name=\"$attribute_name\" rows=\"5\" cols=\"60\">[set $attribute_name]</textarea>"}
			}

			append ams_html "</div> <!-- /form-widget --> </div>"
	}
}




ad_form -extend -name execution -on_submit {

	ad_progress_bar_begin -title "Processando os dados da Ação..." -message_1 "Por Favor, Aguarde..." -message_2 "Ao final deste processo, você será redirecionado/a para a p'agina espelho dessa ação."

	
	foreach listname $listnames {
		 ams::ad_form::save \
        	    -package_key "action-manager" \
	            -object_type "territory_action" \
        	    -list_name $listname \
	            -form_name execution \
	            -object_id $territory_action_id_p

	}


	ad_progress_bar_end -url  add-action?territory_action_id_p=$territory_action_id_p&territory_matrix_id_p=$territory_matrix_id_p
}




