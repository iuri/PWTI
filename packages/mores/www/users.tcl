ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23

} {
	account_id
	{query_id_p ""}
	{lang_p:optional}
}

if {![exists_and_not_null lang_p]} {
	if {$account_id == 1935} {
		set lang_p "es"
	} else {
		set lang_p "todas"
	}
} else {

}

set export_vars "account_id=$account_id&sentimento=0"


	set sql_query_id2 ""

if {$lang_p == "todas" } {
	set sql_lang ""
} else {
	set sql_lang " and substr(lang,1,2) = '$lang_p'"
	append export_vars "&lang_p=$lang_p"
}



if {$query_id_p == "" } {
	set sql_query_id ""
	set sql_query_id2 ""
} else {
	set sql_query_id " and query_id = $query_id_p"
	set sql_query_id2 " and maq.query_id = $query_id_p"
	append export_vars "&query_id_p=$query_id_p"
}
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id $user_id -object_id [ad_conn package_id] -privilege read
permission::require_permission -party_id $user_id  -object_id $account_id -privilege write
set admin_p [permission::permission_p -party_id $user_id  -object_id $account_id -privilege admin]
set admin_geral [permission::permission_p -party_id $user_id  -object_id [ad_conn package_id] -privilege admin]
set write_p [permission::permission_p -party_id $user_id  -object_id $account_id -privilege write]
set action_list ""

set account_name [db_string select_name {select name from mores_accounts where account_id = :account_id}]


set values ""
set values2 ""
set chart_js ""
set max_qtd 0

set cont_date 0
set  days ""
set current_query 0
set cont_query 0

set xml 	""
set xml_dados 	""
set xml_date 	""



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
	}



db_multirow users select_users "SELECT user_id as user_name, sum(qtd) as qtd
  FROM mores_stat_twt_usr
  where account_id = :account_id $sql_query_id $sql_lang
  group by user_id
  order by 2 desc
  limit 300;" {
}

set max_date [db_string select_name "SELECT  to_char(max(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id $sql_lang" -default ""]

set min_date [db_string select_name "SELECT  to_char(min(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id $sql_lang" -default ""]

set updated_at [db_string select_name "SELECT  max(updated_at) FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id " -default ""]

set h [lc_time_system_to_conn $updated_at]

set updated_at [lc_time_fmt $h "%D %H:%M" ]


db_multirow langs select_langs "
	SELECT substr(lang,1,2) as lang, sum(qtd) as qtd
	FROM mores_stat_source_query mi, mores_acc_query maq
	WHERE maq.query_id = mi.query_id and maq.account_id = :account_id $sql_source $sql_query_id2 		 
	GROUP BY substr(lang,1,2)
	ORDER BY 1
" {
	if {$lang == ""} {
		set lang "N. Def."
	}
}



template::head::add_javascript -script $jquery_ready -order 5
template::head::add_javascript -src "/resources/mores/js/jquery-1.2.3.min.js" -order 1

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
