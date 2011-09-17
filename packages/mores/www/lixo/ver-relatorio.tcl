ad_page_contract {
} {
 {filter "0"}
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
	set sql_datai "  and date > '$datai' "
	set sql_datai2 "  and created_at > '$datai' "
} else {
	set sql_datai ""
	set sql_datai2 ""
}


if {$dataf != "" && [string length $dataf] < 15} {
	set sql_dataf "  and date < '$dataf'"
	set sql_dataf2 "  and created_at < '$dataf'"
} else {
	set sql_dataf ""
	set sql_dataf2 ""
}


#db_multirow items select_mentions "SELECT user_id, user_nick, user_name, profile_img, to_char(created_at, 'HH24:MI:SS') as hora,
#       to_char(created_at, 'DD  Mon  YYYY') as date, created_at, updated_at, title, text, lang, source, favicon, 
#        post_url, post_img
#  FROM mores_items3 mi, mores_acc_query maq
#where mi.query_id = maq.query_id and maq.account_id = :account_id
#   $sql_rede -- $sql_datai2 $sql_dataf2
#--  order by created_at desc
#  limit $limit" {
#  	
#}
#<multiple name="items">
#	<h3>@items.date@</h3>
#	<group column="date">
#		<div class="item" style="">
#			
#			<div class="text">@items.text@
#			</div>
#			<div class="details">
#				<div class="source">
#					<span rel="1291660465000" class="date">
#						<a target="_blank" href="@items.post_url@" title="Veja o post original ">@items.hora@</a>
#					</span>  por <a target="_blank" href="http://twitter.com/@items.user_nick@">@items.user_nick@</a> - @items.source@
#				</div>
#			</div>
#		</div>
#	</group>	
#</multiple>
set cont 0
set  days ""
set values ""
set max_qtd 0

#TODO REDES NESTA QUERY
db_multirow datas select_datas "
  SELECT data as dia, sum(qtd) as qtd
  FROM mores_stat_graph msg, mores_acc_query maq
where msg.query_id = maq.query_id and maq.account_id = :account_id and tipo='dia' $sql_datai $sql_dataf
group by date,data
order by date" {
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

db_multirow  querys   select_account {
	SELECT maq.query_id,maq.query_text, sum(qtd) as qtd
	  FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and maq.account_id =:account_id and tipo = 'dia'
	group by maq.query_id, maq.query_text
	order by 3 desc
	} {
	}


db_multirow redes select_redes "SELECT source, qtd
		  FROM mores_stat_source
		  where account_id = :account_id
		  order by qtd desc
  		  limit 15 ;
  		   " {
}
db_multirow users select_users "SELECT user_id as user_name, qtd
  FROM mores_stat_twt_usr
  where account_id = :account_id
  order by qtd desc
  limit 18;" {
}


set qtd_total [db_string select_name "SELECT sum(qtd)  FROM mores_stat_source  where account_id = :account_id;" -default "0"]


set max_date [db_string select_name "SELECT  to_char(max(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id " -default ""]

set min_date [db_string select_name "SELECT  to_char(min(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id" -default ""]
		

