ad_page_contract {
    @author Breno assunção (assuncao.b@gmail.com)
    @creation-date Feb 02, 2011

} -query {
    account_id
    {page:optional}
    {orderby "created_at,desc"}
    {user:optional}
    {query_id_p:optional}
    {source_p:optional}
    {sentimento:optional}
    {datai:optional}
    {dataf:optional}
    {lang_p:optional}
    {limit "80"}
    {rel_p "0"}
}





set css ""


if {$account_id == 1189} {
	set css "/resources/mores/layouts/sebrae/css/css.css"
	template::head::add_css -href "/resources/mores/layouts/sebrae/css/css.css"
}

if {$account_id == 1284} {
	set css "/resources/mores/layouts/jp/css/css.css"
	template::head::add_css -href "/resources/mores/layouts/jp/css/css.css"
}

if {$account_id == 1935} {
	set css "/resources/mores/layouts/ollanta/css/css.css"
	template::head::add_css -href "/resources/mores/layouts/ollanta/css/css.css"
}

if {$css == ""} {
	template::head::add_css -href "/resources/mores/layouts/css.css"
}
set account_id_p $account_id
  
set return_url [ad_return_url]

set return_url [ns_urlencode $return_url]

set fields "<input type=\"hidden\" name=\"account_id\" id=\"account_id\" value=\"$account_id\">"

if {[exists_and_not_null sentimento ] } { 
   	append fields " <input type=\"hidden\" name=\"sentimento\" id=\"sentimento\" value=\"$sentimento\">"
}
if {[exists_and_not_null orderby ] } {
   	append fields "<input type=\"hidden\" name=\"orderby\" id=\"orderby\" value=\"$orderby\">"
}
if {[exists_and_not_null user] } {
   	append fields "<input type=\"hidden\" name=\"user\" id=\"user\" value=\"$user\">"
}
if {[exists_and_not_null query_id_p ]} {
   	append fields "<input type=\"hidden\" name=\"query_id_p\" id=\"query_id_p\" value=\"$query_id_p\">"
}
if {[exists_and_not_null source_p] } {
   	append fields "<input type=\"hidden\" name=\"source_p\" id=\"source_p\" value=\"$source_p\">"
}
 
 
 set sql_date ""
## filtro das datas
if {[exists_and_not_null datai] } {
	set datai2 [lc_time_conn_to_system $datai]
   	append sql_date " and created_at >= '$datai2'"
   	set min_date $datai
} else {
	set min_date [db_string select_min_date {SELECT to_char(o.creation_date -interval '10 days'   , 'YYYY-MM-DD HH24:MI') 
		   FROM mores_accounts maq, acs_objects o
	  where  maq.account_id = :account_id  AND maq.account_id = o.object_id} -default ""]
	  
	set datai $min_date 
}

if {[exists_and_not_null dataf] } {
	set dataf2 [lc_time_conn_to_system $dataf]

   	append sql_date " and created_at <= '$dataf2'"
   	set max_date $dataf
} else {
	set max_date [db_string select_max_date "SELECT  to_char(now(), 'YYYY-MM-DD HH24:MI') " -default ""]
	   	set dataf $max_date
}

    
set account_name [db_string select_name {select name from mores_accounts where account_id = :account_id}]

if {$rel_p == 0} {

	set elements [list  username \
			  [list label username \
		           display_template { @mentions.user_nick@ <br/><a href="user_block-ajax?return_url=$return_url&user_nick=@mentions.user_nick@&source=@mentions.source@&query_id=@mentions.query_id@" style="color:red;">bloquear</a> } \
				   orderby_desc {fs_objects.title desc} \
				   orderby_asc {fs_objects.title asc}] \
			  source [list label source  \
		                         display_template {@mentions.source@}] \
	 		  text \
			  [list label "mention" \
	 		       display_template {
	 		       		<div class="item" style="background-color:@mentions.color@;">
								<div class="user_image">
									<a target="_blank" href="@mentions.user_url@">
										<img src="@mentions.profile_img@">
									</a>
								</div>
								<div class="text">@mentions.text@
								</div>
								<div class="details">
									<div class="source">
										<img src="@mentions.favicon@">&nbsp;
										<span rel="1291660465000" class="date">
											<a target="_blank" href="@mentions.post_url@" title="Veja o post original ">@mentions.hora@</a>
										</span>  por <a target="_blank" href="@mentions.user_url@">@mentions.user_nick@</a> - @mentions.source@
									</div>
								</div>
							</div>}] \
			  created_at \
			  [list label "data" \
			   		display_template {@mentions.date@ @mentions.hora@} \
				   orderby_desc {created_at desc} \
				   orderby_asc {created_at asc}] \
			  sentimento \
			  [list label "sentimento" \
				   display_template {<div id ="item@mentions.mores_post_id@" <ul style="width: 85px;">
				   		<li style="display: block;"><a href="javascript:ajaxpage('sentimento-ajax?sentimento=1&mores_post_id=@mentions.mores_post_id@', 'item2@mentions.mores_post_id@');"><img  src="/resources/mores/positivo.png"></a> </li>
				   		<li style="display: block;"><a href="javascript:ajaxpage('sentimento-ajax?sentimento=2&mores_post_id=@mentions.mores_post_id@', 'item2@mentions.mores_post_id@');"><img  src="/resources/mores/neutro.png"></a></li>
				   		<li style="display: block;"><a href="javascript:ajaxpage('sentimento-ajax?sentimento=3&mores_post_id=@mentions.mores_post_id@', 'item2@mentions.mores_post_id@');"><img  src="/resources/mores/negativo.png"></a> </li>
				   		<li style="display: block;"><a href="javascript:ajaxpage('sentimento-ajax?sentimento=4&mores_post_id=@mentions.mores_post_id@', 'item2@mentions.mores_post_id@');"><img src="/resources/mores/divulgacao.png"></a> </li>
				   </ul> </div>
				   <div id ="item2@mentions.mores_post_id@"></div>}]
			  ]
			 
} else {

			set elements [list  text \
			  [list label "mention" \
	 		       display_template {
	 		       		<div class="item" style="background-color:@mentions.color@;max-width: 863px !important;">
								<div class="user_image">
									<a target="_blank" href="@mentions.user_url@">
										<img src="@mentions.profile_img@">
									</a>
								</div>
								<div class="text">@mentions.text@
								</div>
								<div class="details">
									<div class="source">
										<img src="@mentions.favicon@">&nbsp;
										<span rel="1291660465000" class="date">
											<a target="_blank" href="@mentions.post_url@" title="Veja o post original ">@mentions.hora@</a>
										</span>  por <a target="_blank" href="@mentions.user_url@">@mentions.user_nick@</a> - @mentions.source@
									</div>
								</div>
							</div>}] \
			  created_at \
			  [list label "data" \
			   		display_template {@mentions.date@ @mentions.hora@} \
				   orderby_desc {created_at desc} \
				   orderby_asc {created_at asc}] \
			  
			  ]
			 

}			 
	     ## FILTERS

if {![exists_and_not_null source_p]} {
	set sql_source ""
	set sql_query_id2 ""
} else {
	set sql_source " and source = '$source_p'"
}


if {![exists_and_not_null user]} {
	set sql_user ""
} else {
	set sql_user " and user_name = '$user'"
}

if {![exists_and_not_null lang_p] } {
	set sql_lang ""
} else {
	set sql_lang " and substr(lang,1,2) = '$lang_p'"
}

if {![exists_and_not_null query_id_p ]} {
	set sql_query_id ""
	set sql_query_id2 ""
	db_multirow redes select_redes "SELECT source, sum(qtd) as qtd
		  FROM mores_stat_source
		  where account_id = :account_id $sql_source $sql_lang
		  group by source
		  order by qtd desc
  	 " {
  	  lappend options_list_redes [list "$source - $qtd" $source]
	}

} else {
	set sql_query_id " and query_id = $query_id_p"
	set sql_query_id2 " and maq.query_id = $query_id_p"
	db_multirow redes select_redes "SELECT source,  sum(qtd) as qtd
		  FROM mores_stat_source_query
		  where account_id = :account_id and query_id = :query_id_p $sql_source $sql_lang
  		  group by source
		  order by qtd desc
  	" {
  		lappend options_list_redes [list "$source - $qtd" $source]
	}
	
}
set options_list_langs ""

db_foreach select_langs {} {
    	lappend options_list_langs [list "$lang - $qtd" $lang]
}

set options_list_querys ""

db_multirow users select_users "SELECT user_id as user_name, sum(qtd) as qtd
  FROM mores_stat_twt_usr
  where account_id = :account_id $sql_query_id $sql_lang 
  group by user_id
  order by 2 desc
  limit 100;" {
    	lappend options_list_users [list "$user_name - $qtd" $user_name]
}

db_multirow  querys   select_account "
	SELECT maq.query_id,maq.query_text, COALESCE(qtd,0) as qtd
	  FROM mores_acc_query maq
	  left join (select query_id, sum(qtd) as qtd
	  	from mores_stat_source_query mssq
	  	where 1 = 1 $sql_query_id $sql_source $sql_lang
	  	group by query_id) as dt on ( dt.query_id = maq.query_id)
	WHERE  maq.account_id =:account_id   $sql_query_id2
	--group by maq.query_id, maq.query_text
	order by 3 desc 
	" {
		   	   lappend options_list_querys [list "$query_text - $qtd" $query_id]
	}

	  lappend options_list_sentimento [list "Não Classificado" 0] 
	  lappend options_list_sentimento [list "Positivo" 1]     
	  lappend options_list_sentimento [list "Neutro" 2]     
	  lappend options_list_sentimento [list "Negativo" 3] 
	  lappend options_list_sentimento [list "Divulgação" 4]   
	                
set filters [list \
	sentimento {
         label "Sentimento"
         values $options_list_sentimento
         where_clause " sentimento = :sentimento"
     } \
     query_id_p {
         label "Termo"
         values $options_list_querys
         where_clause " maq.query_id = :query_id_p"
     } \
     source_p {
         label "Rede"
		 values $options_list_redes
         where_clause " source = :source_p"
     } \
     user {
         label "Usuário do twitter"
         values $options_list_users
         where_clause " user_name = :user"
     } \
     lang_p {
         label "Língua"
         values $options_list_langs
         where_clause " lang = :lang_p"
     } \
     datai {} \
     dataf {} \
     date {
         label "Usuário do twitter"
         where_clause " user_name = :user"
     } \
     account_id 
]


set actions "\"\" \"account?account_id=$account_id\" \"#mores.account_view#\""
if {![exists_and_not_null format]} {
    set format table
}



template::list::create \
    -name mentions \
    -multirow mentions \
    -key account_id \
    -actions $actions \
    -bulk_actions "" \
    -bulk_action_export_vars [export_vars {account_id datai dataf}] \
    -selected_format $format \
    -pass_properties "" \
    -filters $filters \
    -page_size 20 \
    -page_flush_p t \
    -page_query_name select_mentions_pagination \
    -elements $elements 


db_multirow -extend {account_id color datai dataf user_url date hora } mentions select_mentions {} {



	switch $source {
		"facebook" {
			set user_url "http://www.facebook.com/profile.php?id=$user_id"
			if {[exists_and_not_null post_id]} {
				set story_fbid [lindex [split $post_id '_'] 1]
			} else {
				set post_id ""
				set story_fbid ""
			}
			if {$story_fbid != ""} {
				set post_url "http://www.facebook.com/permalink.php?story_fbid=$story_fbid&id=$user_id"	
			} else {
				set position [string first "facebook.com" $post_url]
				if {$position != -1} {
					#do nothing, is a link generated by sm
				} else {
					set post_url "Nao encontrado"
				}
			}
			
		}
		"twitter" {
			set user_url "http://twitter.com/$user_nick"
			#set post_url
		}
		default {
			set color ""
			#set post_url
			set user_url "nao encontrado"
		}
	}
	


	switch $sentimento {
		1 {
			set color "#00FF00"
		}
		2 {
			set color "#FFFF00"
		}
		3 {
			set color "#FF6347"
		}
		4 {
			set color "#63B8FF"
		}
		default {
			set color ""
		}
	}
	
	set h [lc_time_system_to_conn $datetime]

	set hora [lc_time_fmt $h "%T" ]
	
	set date [lc_time_fmt $h "%D" ]
}

set package_id [ad_conn package_id]
set extra_css ""
set extra_css [parameter::get -parameter "aditional_css" -package_id $package_id] 	

