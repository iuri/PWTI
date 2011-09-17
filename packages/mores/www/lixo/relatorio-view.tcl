ad_page_contract {
} {
 {filter "0"}
 {sources ""}
 {grafico "Line"}
 {datai ""}
 {dataf ""}
 {query_id_p ""}
 account_id
}

set account_name [db_string select_name {select name from mores_accounts where account_id = :account_id}]


if {$sources != "" && [string length $sources] < 15} {
	set sql_source " and source = '$sources'"
} else {
	set sql_source ""
}

if {$query_id_p == "" } {
set texto_topo "Gráfico de "
	set sql_query_id ""
	set sql_query_id2 ""
	set termo "Todas"
	set qtd_rede 0
	db_multirow redes select_redes "SELECT source, qtd
		  FROM mores_stat_source
		  where account_id = :account_id $sql_source
		  order by qtd desc
  	 " {
  	 incr qtd_rede
	}

} else {
	set termo [db_string query_text {select query_text from mores_acc_query where query_id = :query_id_p}]
	set sql_query_id " and query_id = $query_id_p"
	set sql_query_id2 " and maq.query_id = $query_id_p"
	set qtd_rede 0
	db_multirow redes select_redes "SELECT source, qtd
		  FROM mores_stat_source_query
		  where account_id = :account_id and query_id = :query_id_p $sql_source
		  order by qtd desc
  	" {
  	incr qtd_rede
	}
	
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

set cont 0
set  days ""
set values ""
set max_qtd 0

#TODO REDES NESTA QUERY

set colors {"red" "blue" "green" "yellow" "black" "orange" "gray" "pink" "dark-red" "dark-blue" "dark-green" "dark-yellow" "dark-black" "dark-orange" "dark-gray" "dark-pink" }
set current_query 0
set cont_query 0

set cont_dados 0

set xml 	""
set xml_dados 	""
set xml_date 	""
db_foreach select_grafico "	select tabela.date, dia, COALESCE(msg2.qtd,0) as qtd 
		from (SELECT distinct  date, data as dia  
			FROM mores_stat_graph msg, mores_acc_query maq
			WHERE maq.account_id = :account_id and msg.account_id = maq.account_id and tipo = 'dia' $sql_query_id2) as tabela
		left join (select sum(qtd) as qtd, date 
				from mores_stat_graph WHERE account_id = :account_id $sql_source $sql_query_id
		group by  date) msg2 on msg2.date = tabela.date  
		order by date    
	" {

  			
		if {$cont_query  == 0} {
  			append xml_dados "\nmyChart.setDataArray(\["
		}
			incr cont_query

  		
  		if {$cont_dados > 0} {
  			append xml_dados ","
  		}
  		  		#regsub -all {/} $dia {' / '} dia
  		append xml_dados "\['$dia', $qtd\]"
  		incr cont_dados
  }
   append xml_dados "\], 'red');"  		
  	
db_multirow datas select_datas "
  SELECT data as dia, sum(qtd) as qtd
  FROM mores_stat_graph msg, mores_acc_query maq
where msg.query_id = maq.query_id and maq.account_id = :account_id and tipo='dia' $sql_datai $sql_dataf $sql_query_id2
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

set qtd_query 0
set value_query ""
db_multirow  querys   select_account "
	SELECT maq.query_id,maq.query_text, sum(qtd) as qtd
	  FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and maq.account_id =:account_id and tipo = 'dia' $sql_query_id2
	group by maq.query_id, maq.query_text
	order by 3 desc
	" {
	
	incr qtd_query
	
	}

#set qtd_rede 0
#db_multirow redes select_redes "SELECT source, qtd
#		  FROM mores_stat_source
#		  where account_id = :account_id
#		  order by qtd desc
#  		   ;
#  		   " {
#  		   incr qtd_rede
#}
db_multirow users select_users "SELECT  user_id as user_name, sum(qtd) as qtd
  FROM mores_stat_twt_usr
  where account_id = :account_id $sql_query_id
  group by user_id
  order by qtd desc
  limit 15;" {
}


set qtd_users [db_string select_name "select count(*) from (SELECT distinct user_id FROM mores_stat_twt_usr  where account_id = :account_id $sql_query_id) as tabela;" -default "0"]

set qtd_total [db_string select_name "SELECT sum(qtd)  FROM mores_stat_source_query  where account_id = :account_id $sql_source $sql_query_id;" -default "0"]


set max_date [db_string select_name "SELECT  to_char(max(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id $sql_dataf" -default ""]

set min_date [db_string select_name "SELECT  to_char(min(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id $sql_datai" -default ""]
		




##### HORA


set cont_query 0
set cont_dados  0
db_foreach select_grafico2 " select hora as hour, COALESCE(msg3.qtd,0) as qtd 
					  from (SELECT distinct data as hora FROM mores_stat_graph msg
						WHERE msg.tipo = 'hora' $sql_query_id
					   ) as base
					left join (select sum(qtd) as qtd, data 
						from mores_stat_graph  where account_id = :account_id $sql_query_id $sql_source and tipo = 'hora'
						group by  data) msg3 on  msg3.data = base.hora
						order by  hora
	" {
	
	
	if {$cont_query  == 0} {
  			append xml_dados_hora "\nmyChart.setDataArray(\["
		}
			incr cont_query

  		
  		if {$cont_dados > 0} {
  			append xml_dados_hora ","
  		}
  		  		#regsub -all {/} $dia {' / '} dia
  		append xml_dados_hora "\['$hour', $qtd\]"
  		incr cont_dados
  }
   append xml_dados_hora "\], 'red');"  		



#SENTIMENTO
set sent(1) 0
set sent(2) 0
set sent(3) 0
set sent(4) 0

db_foreach sentimento "SELECT sentimento, count(*) as qtd
  FROM mores_items3 mi, mores_acc_query maq 
  where maq.account_id = :account_id and  maq.query_id = mi.query_id and sentimento <> 0 $sql_query_id2  and created_at > '2010-11-20' $sql_source
  group by sentimento;" {
  	set sent($sentimento) [expr $qtd *1.0]
}

	append value_query "\['Positivo', $sent(1)\], \['Negativo', $sent(3)\], \['Neutro', $sent(2)\], \['Divulgação', $sent(4)\]"



