ad_page_contract {
} {
 {sources ""}
 {grafico "Line"}
 {datai ""}
 {dataf ""}
 {limit "500"}
 account_id
}

set account_name [db_string select_name {select name from mores_accounts where account_id = :account_id}]



if {$sources != "" && [string length $sources] < 15} {
	set sql_rede " and source = '$sources'"
} else {
	set sql_rede ""
}


if {$datai != "" && [string length $datai] < 15} {
	set sql_datai "  and created_at > '$datai' "
} else {
	set sql_datai ""
}


if {$dataf != "" && [string length $dataf] < 15} {
	set sql_dataf "  and created_at < '$dataf'"
} else {
	set sql_dataf ""
}


db_multirow items select_mentions "SELECT distinct user_id, user_nick, user_name, profile_img, to_char(created_at, 'HH24:MI:SS') as hora,
       to_char(created_at, 'DD  Mon  YYYY') as date, created_at, updated_at, title, text, lang, source, favicon, 
        post_url, post_img
  FROM mores_items3 mi, mores_acc_query maq 
		where mi.query_id = maq.query_id and maq.account_id =:account_id $sql_rede $sql_datai $sql_dataf
  order by created_at desc
  limit $limit" {
  	
}
set cont 0
set  days ""
set values ""
set max_qtd 0
db_multirow datas select_datas "SELECT count(*) as qtd,  date as dia
	from (select to_char(created_at, 'DD/MM') as date, to_char(created_at, 'YYYY MM DD') as date2
	FROM mores_items3 mi , mores_acc_query maq 
		where mi.query_id = maq.query_id and maq.account_id =:account_id $sql_rede $sql_datai $sql_dataf) tabela
  group by 2, date2
  order by date2" {
  	if {$qtd > $max_qtd} {
  		set max_qtd $qtd
  	}
  
  	if {$cont == 0} {
  		append days "'$dia'"
  		append values "'$qtd'"
  	} else {
   		append days ",'$dia'"
  		append values ",'$qtd'"	
  	}
  	incr cont
}

db_multirow redes select_redes "SELECT count(*) as qtd,  source
  FROM mores_items3 mi, mores_acc_query maq 
		where mi.query_id = maq.query_id and maq.account_id =:account_id  $sql_rede $sql_datai $sql_dataf
  group by source
  order by source" {
  	
}

db_multirow querys  select_account {
	  SELECT account_id, maq.query_id, query_text, isactive, last_request, COALESCE(mi.qtd,0) as qtd
 	FROM mores_acc_query maq
 		left join (select query_id, count(*) as qtd from mores_items3 group by query_id) mi 
 		on  (mi.query_id = maq.query_id )
 	where maq.account_id =:account_id
	} {
			
	}

set qtd_1 [db_string select_name "select count(*) from mores_items3 where query_id = 1 $sql_rede $sql_datai $sql_dataf " -default ""]

set qtd_2 [db_string select_name "select count(*) from mores_items3 where query_id = 2 $sql_rede $sql_datai $sql_dataf" -default ""]

set qtd_3 [db_string select_name "select count(*) from mores_items3 where query_id = 3 $sql_rede $sql_datai $sql_dataf" -default ""]

set qtd_total [db_string select_name "select count(post_id)
										from mores_items3 mi, mores_acc_query maq 
										where mi.query_id = maq.query_id and maq.account_id =:account_id $sql_rede $sql_datai $sql_dataf" -default ""]


set max_date [db_string select_name "select to_char(max(created_at), 'DD/MM/YYYY') as date 
										from mores_items3 mi, mores_acc_query maq 
										where mi.query_id = maq.query_id and maq.account_id =:account_id $sql_rede $sql_datai $sql_dataf " -default ""]

set min_date [db_string select_name "select to_char(min(created_at), 'DD/MM/YYYY') as date
										from mores_items3 mi, mores_acc_query maq 
										where mi.query_id = maq.query_id and maq.account_id =:account_id $sql_rede $sql_datai $sql_dataf" -default ""]
