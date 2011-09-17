ad_page_contract {
} {
 {filter "0"}
 {sources ""}
 {grafico "Line"}
 {datai ""}
 {dataf ""}
 {query_id_p:multiple  "0"}
 account_id
}

set account_name [db_string select_name {select name from mores_accounts where account_id = :account_id}]


if {$datai != "" && [string length $datai] < 15} {
	set sql_datai "  and date >= '$datai' "
	set sql_datai2 "  and to_char(created_at, 'YYYY-MM-DD') >= '$datai' "
	

} else {
	set sql_datai ""
	set sql_datai2 ""
}


if {$dataf != "" && [string length $dataf] < 15} {
	set sql_dataf "  and date <= '$dataf'"
	set sql_dataf2 "  and to_char(created_at, 'YYYY-MM-DD') <= '$dataf'"
} else {
	set sql_dataf ""
	set sql_dataf2 ""
}

if {$sources != "" && [string length $sources] < 15} {
	set sql_source " and source = '$sources'"
} else {
	set sql_source ""
}
 set html_rede ""
 set html_query ""
 set html_user ""
 
 set todas 0
 foreach query_id $query_id_p {
 	if {$query_id == "0"} {
 		set todas 1
 	}
 }
if {$todas == 1 } {
	set texto_topo "Gráfico de "
	set sql_query_id ""
	set sql_query_id2 ""
	set termo "Todos"
	set qtd_rede 0
	db_multirow redes select_redes "SELECT source , sum(qtd) as qtd
		  FROM mores_stat_graph
		where account_id = :account_id  and tipo = 'dia' $sql_query_id $sql_datai $sql_dataf  $sql_source	
		group by source
		order by qtd desc
		limit 15
  	 " {
  		 incr qtd_rede
  		 append html_rede "<tr style=\"height: 28px;\"><td><b>$source </b></td> <td> $qtd menções</td> </tr>\n"
	}

} else {
	set sql_query_id " and query_id in ( [join $query_id_p ,] ) "
	set termo [db_list query_text "select query_text from mores_acc_query where 1 = 1 $sql_query_id "]

	set sql_query_id2 " and maq.query_id in ( [join $query_id_p ,] )"
	set qtd_rede 0
	
	db_multirow redes select_redes "
		SELECT source , sum(qtd) as qtd
		  FROM mores_stat_graph
		where account_id = :account_id  and tipo = 'dia' $sql_query_id $sql_datai $sql_dataf  $sql_source	
		group by source
		order by qtd desc
		limit 15
  	" {

#	db_multirow redes select_redes "SELECT source,  sum (qtd) as qtd
#		  FROM mores_stat_source_query
#		  where account_id = :account_id $sql_query_id  $sql_source
#  		  group by source
#		  order by qtd desc
#  	" 
  		incr qtd_rede
  		append html_rede "<tr style=\"height: 28px;\"><td><b>$source </b></td> <td> $qtd menções</td> </tr>\n"
	}
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


set cabecalho " data.addColumn('string', 'data');\n"

              
        
set qtd_rows [db_string get_rows "select count(*) from ( SELECT distinct date
			FROM mores_stat_graph msg, mores_acc_query maq WHERE maq.account_id = :account_id 
			and msg.account_id = maq.account_id and tipo = 'dia' $sql_query_id2  $sql_datai $sql_dataf ) as tabela" -default "0"]       
set incremento_grafico_dia [expr round($qtd_rows / 10.0)]

			
set next_day 0
set current_day ""
set cont_day -1
set cont_word 0
db_foreach select_grafico_2 "	select tabela.query_text , tabela.date, dia, COALESCE(msg2.qtd,0) as qtd 
		from (SELECT distinct  maq.query_id, query_text,date, data as dia  
			FROM mores_stat_graph msg, mores_acc_query maq
			WHERE maq.account_id = :account_id and msg.account_id = maq.account_id and tipo = 'dia' $sql_query_id2  $sql_datai $sql_dataf) as tabela
		left join (select query_id, sum(qtd) as qtd, date 
				from mores_stat_graph WHERE account_id = :account_id  and tipo = 'dia' $sql_source $sql_query_id  $sql_datai $sql_dataf
		group by  query_id, date) msg2 on msg2.date = tabela.date and msg2.query_id = tabela.query_id   
		order by date, query_text    	
" {
		if {$current_day != $dia} {
			set current_day $dia
			incr cont_day
			set cont_word 0
			set dados_dia_coluna ""
			if {$cont_day == $next_day} {
				incr next_day $incremento_grafico_dia
			} else {
				set dia ""			
			}
			append tabela " data.setCell($cont_day, $cont_word, '$dia');\n"			
		}
		incr cont_word		
		if {$cont_day == 1} {
			append cabecalho " data.addColumn('number', '$query_text');\n"			
		}

		append tabela " data.setCell($cont_day, $cont_word, $qtd);\n"	
		if {$cont_word == 1} {	
			append dados_dia_coluna "\['$query_text', $qtd\]"
		} else {
			append dados_dia_coluna ",\n\['$query_text', $qtd\]"
		}	
}		
# set dados_dia_coluna "\['Austria', 1336060\],
#	                \['Belgium', 3817614\],
#	                \['Czech Republic', 1063414\],
#	                \['Finland', 1104797\],
#	                \['France', 6651824\],
#	                \['Germany', 15727003\]"

set dados_dia_grafico $cabecalho
append dados_dia_grafico   "data.addRows([expr $cont_day + 1]);"
append dados_dia_grafico $tabela

set dias_list [list]
db_foreach select_grafico "	select tabela.date, dia, COALESCE(msg2.qtd,0) as qtd 
		from (SELECT distinct  date, data as dia  
			FROM mores_stat_graph msg, mores_acc_query maq
			WHERE maq.account_id = :account_id and msg.account_id = maq.account_id and tipo = 'dia' $sql_query_id2  $sql_datai $sql_dataf) as tabela
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
  		#append xml_dados "\['$dia', $qtd\]"
  		append xml_dados "\[$cont_dados, $qtd\]"
  		set dias($cont_dados) $dia
  		lappend dias_list $dia
  		incr cont_dados
  }
   append xml_dados "\], 'line 1');"  	
   
  set contd 0 	
  if {$cont_dados <= 10} {
  	foreach one_day $dias_list {
  		append labels "myChart.setLabelX(\[$contd,'$one_day'\]);\n"
  		incr contd
  	}
  }	else {
  	set incremento [expr $cont_dados / 10.0]
 	#set incremento [expr round($cont_dados / 10.0)]
  	
  	foreach x {0 1 2 3 4 5 6 7 8 9} {
  		set posicao [expr round($x * $incremento)]
		append labels "myChart.setLabelX(\[$posicao,'$dias($posicao)'\]);\n"
  		 	
  	}
  }
  	
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
	WHERE msg.query_id = maq.query_id and maq.account_id =:account_id and tipo = 'dia' $sql_query_id2  $sql_datai $sql_dataf
	group by maq.query_id, maq.query_text
	order by 3 desc
" {
	incr qtd_query
	set query($query_id) $query_text
	append html_query "<tr style=\"height: 28px;\"><td><b>$query_text </b></td> <td> $qtd menções</td> </tr>"
	append html_query2 "<li><b>$query_text </b> ($qtd) </li>"
}

db_multirow  querys2   select_account "
	SELECT maq.query_id,maq.query_text
	  FROM mores_acc_query maq
	WHERE  maq.account_id =:account_id 
	" {
	set query($query_id) $query_text
	}

db_multirow users select_users "
		Select  user_nick, count(*) as qtd from mores_items3  mi
		where query_id in(select query_id from mores_acc_query where account_id = :account_id $sql_query_id)  $sql_datai2 $sql_dataf2  and user_nick <> ''
		group by user_nick
		order by qtd desc
		limit 15" {
 	append html_user "<tr style=\"height: 28px;\"><td><a href=\"http://twitter.com/$user_nick\" ><b>@$user_nick </b> </a> </td><td> http://twitter.com/$user_nick </td> <td> $qtd menções</td> </tr>\n"
}

#db_multirow users select_users "SELECT  user_id as user_name, sum(qtd) as qtd
#  FROM mores_stat_twt_usr
#  where account_id = :account_id $sql_query_id
#  group by user_id
#  order by qtd desc
#  limit 15;" {
# 	append html_user "<tr style=\"height: 28px;\"><td><a href=\"http://twitter.com/$user_name\" ><b>@$user_name </b> </a> </td><td> http://twitter.com/$user_name </#td> <td> $qtd menções</td> </tr>\n"
#}
									
set qtd_users [db_string select_name "select count(*) from (Select distinct user_nick from mores_items3  mi
		where query_id in(select query_id from mores_acc_query where account_id = :account_id $sql_query_id)  $sql_datai2 $sql_dataf2  
) as tabela;" -default "0"]

set qtd_total [db_string select_name "SELECT sum(qtd)  FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and maq.account_id =:account_id and tipo = 'dia' $sql_query_id2  $sql_datai $sql_dataf" -default "0"]


set max_date [db_string select_name "SELECT  to_char(max(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id $sql_dataf" -default ""]

set min_date [db_string select_name "SELECT  to_char(min(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id $sql_datai" -default ""]
		




##### HORA

set cabecalho2 " data.addColumn('string', 'hora');\n"
set current_hour ""
set cont_hour -1
set cont_word2 0
set tabela2 "" 
db_foreach select_grafico2 " select base.query_id, hora as hour, COALESCE(msg3.qtd,0) as qtd 
					  from (SELECT distinct  maq.query_id, data as hora FROM mores_stat_graph msg, mores_acc_query maq
							WHERE maq.account_id = :account_id  and msg.tipo = 'hora' $sql_query_id2
					   ) as base
					left join (select query_id,sum(qtd) as qtd, data 
						from mores_stat_graph  where account_id = :account_id $sql_query_id $sql_source and tipo = 'hora'  $sql_datai $sql_dataf
						group by  data,query_id) msg3 on  msg3.data = base.hora  and msg3.query_id = base.query_id
						order by  hora,query_id
	" {
	
	
		if {$current_hour != $hour} {
			set current_hour $hour
			incr cont_hour
			set cont_word2 0
				
			append tabela2 " data.setCell($cont_hour, $cont_word2, '$hour');\n"			
		}
		incr cont_word2		
		if {$cont_hour == 1} {
			append cabecalho2 " data.addColumn('number', '$query($query_id)');\n"			
		}
		append tabela2 " data.setCell($cont_hour, $cont_word2, $qtd);\n"	
		
}		
       
set dados_hora_grafico $cabecalho2
append dados_hora_grafico   "data.addRows([expr $cont_hour + 1]);"
append dados_hora_grafico $tabela2



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


set cont_query_sent 0
set current_query ""
db_foreach sentimento "select  query_text, base.sentimento, COALESCE (qtd,0) as qtd from 
	(SELECT distinct maq.query_id,query_text, sentimento
		FROM mores_sentimento mi, mores_acc_query maq 
		where maq.account_id = :account_id $sql_query_id2
		order by query_text, sentimento 
	) as base
	
	left join (SELECT query_id, sentimento, count(*) as qtd
	  FROM mores_items3 mi
	  where   sentimento <> 0 $sql_datai2 $sql_dataf2  $sql_query_id $sql_source
	  group by query_id, sentimento 
	) sent on base.query_id = sent.query_id 
		and base.sentimento = sent.sentimento
  order by base.query_id, sentimento;
  " {
  	if {$query_text != $current_query} {
  		if {$cont_query_sent >= 1 } {
  			set total [expr $qtd_sent(1)+ $qtd_sent(2)+ $qtd_sent(3)+ $qtd_sent(4)]
  			if {$total > 0} {
  				set perc_positivo [expr ($qtd_sent(1)*1.0 / $total) *100 ]
				set perc_neutro [expr (($qtd_sent(2)*1.0 + $qtd_sent(4)) / $total) * 100]
				set aceitacao [expr round($perc_positivo+ ( $perc_neutro / 2))]
 			} else {
				set aceitacao 50
 			}
 			append dados_aceitacao "data.setValue([expr $cont_query_sent -1], 0, '$current_query');
									data.setValue([expr $cont_query_sent -1], 1, $aceitacao); "
  		}
  		 incr cont_query_sent
  		set current_query $query_text
  		set qtd_sent(1) 0
  		set qtd_sent(2) 0
  		set qtd_sent(3) 0
  		set qtd_sent(4) 0
  	}
  
  	set qtd_sent($sentimento) $qtd
}
set total [expr $qtd_sent(1)+ $qtd_sent(2)+ $qtd_sent(3)+ $qtd_sent(4)]
if {$total > 0} {
	set perc_positivo [expr ($qtd_sent(1)*1.0 / $total) *100 ]
	set perc_neutro [expr (($qtd_sent(2)*1.0 + $qtd_sent(4)) / $total) * 100]
	set aceitacao [expr round($perc_positivo+ ( $perc_neutro / 2))]
} else {
	set aceitacao 50
}
append dados_aceitacao "data.setValue([expr $cont_query_sent -1], 0, '$current_query');
						data.setValue([expr $cont_query_sent -1], 1, $aceitacao); "
			

set base "http://pwti.com.br"
set html "<html lang=\"pt\" xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:v=\"urn:schemas-microsoft-com:vml\">
	<head>
		<title>Planeta MPI</title>
		<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\">
		<link rel=\"stylesheet\" type=\"text/css\" href=\"$base/resources/mores/mores.css\" /> 
		<link rel=\"stylesheet\" type=\"text/css\" href=\"$base/resources/mores/styles.css\" />
		<link href=\"css/cssrelatorio.css\" rel=\"stylesheet\" type=\"text/css\" />
		<script type=\"text/javascript\" src=\"$base/resources/mores/js/jscharts.js\"></script>

	</head>
	<body>
		<div class=\"ctn\">
			<div class=\"header\"> </div>
			<div class=\"ctnAll\">
		"

append html "
	<style>
	.relatorio{ font:normal 150% normal arial,sans-serif;} 
	ol li{  padding:10px;}
	pre{  font-size:160%;}
	h3 img {width:50px;}
	#relatorio {margin: 0 auto;  width: 1024px;}
	h2 { color: #3333EE !important; background: none repeat scroll 0 0 #EEEEEE;}
	.right { float: left; margin-bottom: 54px; width: 26%;  }
	.bloco { background: none repeat scroll 0 0 #CDCDCD;}
	.lista_bloco { font-size: 90%; padding: 10px; width: 100%;}
	
	* { margin:0; padding:0; font-family:arial; font-size:12px;}
	body {}
	a {text-decoration:none;}
	a:hover {text-decoration:underline;}
	h2 { color:#ff6701; text-align:center;  font-size:14px; font-weight:bold;}
	.ctn {width:1008px; margin:50px auto 0 auto;}
	.header {background:url($base/resources/mores/logoplaneta.jpg) no-repeat;  height:120px; margin-bottom:35px;}

	.ctnAll {}
	.ctnAll .block{ margin:25px 0;}
	.ctnAll .descr {margin:8px 5px;font-size:14px; font-weight:bold; }
	.ctnAll .tblock {background:url($base/resources/mores/titulo_bloco.jpg) no-repeat;  height:30px; color:#fff; margin:6px 0; font-size:18px; font-weight:bold; padding:0 10px; line-height: 27px;}
	.ctnAll .cblock  {border:1px solid #ccc;margin:6px 3px; padding:6px;-moz-border-radius: 10px;	-webkit-border-radius: 10px; border-radius: 10px;}
	.ctnAll .bgcblock {background:#fff url($base/resources/mores/bgcblock.jpg) repeat-x;} /*Class para bg degrade*/
	.footer {}
	.lista {    margin-left: 83px;}
	.lista li {font-size:16px;}
	 </style>


	<div class=\"block\">
		<div class=\"tblock\">Relatório do Planeta (pwti.com.br)  - Período $min_date - $max_date</div>
		<p class=\"descr\">Relatório do Monitoramento nas Redes Sociais: $account_name  </p>
	</div>	
	<div class=\"block\">
		<div class=\"tblock\">Resumo da Conta </div>
		<div class=\"cblock\">
			<table>
				<tr>
					<td  style=\"width: 50%;\">
						<ul  class=\"lista\">
							<li style=\"margin-top: 15px;\"> <strong>Termo(s) Monitorado(s): </strong>
								<ul style=\"margin-left: 30px; list-style: square outside none;\">
									$html_query2
								</ul> <br /></li>
							
							<li style=\"margin-top: 15px;\"> <strong>Período Avaliado: </strong>$min_date a $max_date <br /></li>
							<li style=\"margin-top: 15px;\"> <strong>Menções nas Redes: </strong>$qtd_total <br /></li>
							<li style=\"margin-top: 15px;\"> <b>Total de Usuários que mencionaram: </b>$qtd_users <br /></li>
							<li style=\"margin-top: 15px;\"> <b>Total de Redes com menções: </b>$qtd_rede </li>
						</ul>
					</td>
					<td> 
					"
					
					append html "  <script type=\"text/javascript\" src=\"http://www.google.com/jsapi\"></script>"
				if {$qtd_query == 1} {
				append html "
						<script type=\"text/javascript\">
						  google.load('visualization', '1', {packages: \['imagepiechart'\]});
						</script>
						<script type=\"text/javascript\">
						  function drawVisualization() {
							// Create and populate the data table.
							var data = new google.visualization.DataTable();
							data.addColumn('string', 'Sentimento');
							data.addColumn('number', 'Número de menções');
							data.addRows(4);
							data.setValue(0, 0, 'Positivo');
							data.setValue(0, 1, $sent(1));
							data.setValue(1, 0, 'Neutro');
							data.setValue(1, 1, $sent(2));
							data.setValue(2, 0, 'Negativo');
							data.setValue(2, 1, $sent(3));
							data.setValue(3, 0, 'Divulgação');
							data.setValue(3, 1, $sent(4));
				
							// Create and draw the visualization.
							new google.visualization.ImagePieChart(document.getElementById('grafico_sentimento')).
							  draw(data, {is3D:true,color:'00FF00,FFFF00,FF0000,0000FF',width:450,height:350});
						  }

						  google.setOnLoadCallback(drawVisualization);
						</script>
    		    <div id=\"grafico_sentimento\" style=\"width: 487px; height: 400px;\"></div>
    		    "
					append html2 "	<div id=\"graph-sent\" style=\"overflow: hidden; width: 487px;\">Loading graph...</div>
						<script type=\"text/javascript\">
							var myData = new Array($value_query);
							var colors = \['#00FF00','#FF0000',  '#00FFFF', '#0000FF'\];
							var myChart = new JSChart('graph-sent', 'pie');
							myChart.setDataArray(myData);
							myChart.colorizePie(colors);
							myChart.setTitle('Análise do Sentimento nas Redes(%)');
							myChart.setTitleColor('#000000');
							myChart.setTitleFontSize(12);
							myChart.setTextPaddingTop(30);
							myChart.setSize(500, 324);
							myChart.setPiePosition(258, 170);
							myChart.setPieRadius(105);
							myChart.setPieUnitsColor('#0000FF');
							myChart.setBackgroundImage('$base/resources/mores/chart_bg2.jpg');
							myChart.draw();
						</script>
					"
				}
		
		append html "
					</td>
				</tr>
			</table>
		</div>
		
		<div class=\"cblock\">
			<p class=\"descr\">Indicador da aceitação nas Redes Sociais </p>
			<script type=\"text/javascript\">
			  google.load('visualization', '1', {packages: \['gauge'\]});
			</script>
			<script type=\"text/javascript\">
			  function drawVisualization() {
				// Create and populate the data table.
				var data = new google.visualization.DataTable();
				data.addColumn('string', 'Termo monitorado');
				data.addColumn('number', 'Aceitacao');
				data.addRows($cont_query_sent);
				$dados_aceitacao
				// Create and draw the visualization.
				new google.visualization.Gauge(document.getElementById('termometros')).
				  draw(data,{greenFrom:55,greenTo:100,yellowFrom:45,yellowTo:55,redFrom:0,redTo:45});
			  }
			  google.setOnLoadCallback(drawVisualization);
			</script>
			<div id=\"termometros\" style=\"width:900px; height: 300px;\"></div>
			
		</div>
	</div>
	"
	
	

	
	if {$cont > 1} {
		append html "
			<script type=\"text/javascript\">
			  google.load('visualization', '1', {packages: \['imagelinechart'\]});
			</script>
			<script type=\"text/javascript\">
			  function drawVisualization() {
				// Create and populate the data table.
				var data = new google.visualization.DataTable();
				$dados_dia_grafico
			  // Create and draw the visualization.
				new google.visualization.ImageLineChart(document.getElementById('visualization')).
				    draw(data, { min: 0});  
			  }
			  google.setOnLoadCallback(drawVisualization);
			</script>"
	} else {
		append html "
			  <script type=\"text/javascript\">
			  google.load('visualization', '1', {packages: \['corechart'\]});
			</script>
			<script type=\"text/javascript\">
			  function drawVisualization() {
				// Create and populate the data table.
				var data = new google.visualization.DataTable();
				var raw_data = \[$dados_dia_coluna\];
				
				var years = \['$min_date'\];
				                
				data.addColumn('string', 'Dia');
				for (var i = 0; i  < raw_data.length; ++i) {
				  data.addColumn('number', raw_data\[i\]\[0\]);    
				}
				
				data.addRows(years.length);
			  
				for (var j = 0; j < years.length; ++j) {    
				  data.setValue(j, 0, years\[j\].toString());    
				}
				for (var i = 0; i  < raw_data.length; ++i) {
				  for (var j = 1; j  < raw_data\[i\].length; ++j) {
				    data.setValue(j-1, i+1, raw_data\[i\]\[j\]);    
				  }
				}
				// Create and draw the visualization.
				new google.visualization.ColumnChart(document.getElementById('visualization')).
				    draw(data,
				         {title:\"Distribuição das menções por termo monitorado\",
				          height:400,
                 		 axisTitlesPosition:'in'}
				    );
			  }
			  google.setOnLoadCallback(drawVisualization);
			</script>"
    
    }
    
    append html "
	<div class=\"block\">
		<div class=\"tblock\">Menções nas redes por dia (Período $min_date - $max_date) </div>
		<div class=\"cblock\">
			<p class=\"descr\">Comparativo por palavra chave: </p>
		    <div id=\"visualization\" style=\"width: 990px; height: 400px;\"></div>
    	</div>"
	if {$cont > 1} {
		append html2 "
		<div class=\"cblock\">
			<p class=\"descr\">Total das menções por dia: </p>
			<div id=\"graph\"  style=\"overflow: hidden; width: 988px;\">Loading graph...</div>
			<script type=\"text/javascript\">
				var myChart = new JSChart('graph', 'line');
				//myChart.setDataArray(myData);
				$xml_dados
				myChart.setTitle('Total de Menções / DIA');
				myChart.setTitleColor('#8E8E8E');
				myChart.setTitleFontSize(11);
				myChart.setAxisNameX('');
				myChart.setAxisNameY('');
				myChart.setAxisColor('#000000');
				myChart.setAxisValuesColor('#0000FF');
				myChart.setAxisPaddingLeft(100);
				myChart.setAxisPaddingRight(120);
				myChart.setAxisPaddingTop(50);
				myChart.setAxisPaddingBottom(40);
				myChart.setAxisValuesNumberX(10);
				myChart.setShowXValues(false);
				$labels				
				myChart.setGraphExtend(true);
				myChart.setGridColor('#c2c2c2');
				myChart.setLineWidth(2);
				myChart.setLineColor('#FF0000', 'red');
				myChart.setLineColor('#FF0000', 'yellow');
				myChart.setSize(1015, 321);
				myChart.setBackgroundImage('$base/resources/mores/chart_bg.jpg');
				myChart.draw();
				
			</script>
		</div>"
}		
append html "	</div>

	<div class=\"block\">
		<div class=\"tblock\">Menções nas redes por Hora  (Período $min_date - $max_date)</div>
		<div class=\"cblock\">
		  <script type=\"text/javascript\">
      google.load('visualization', '1', {packages: \['imagelinechart'\]});
    </script>
    <script type=\"text/javascript\">
      function drawVisualization() {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
			$dados_hora_grafico      
        // Create and draw the visualization.
        new google.visualization.ImageLineChart(document.getElementById('visualization_hora')).
            draw(data, null);  
      }
          google.setOnLoadCallback(drawVisualization);
    </script>
    
    	 <div id=\"visualization_hora\" style=\"width: 990px; height: 400px;\"></div>
		</div>
	</div>
	<div class=\"block\">
		<div class=\"tblock\">Usuários mais ativos (Período $min_date - $max_date)</div>
		<div class=\"cblock\">
			<table clear=\"all\"  border=\"0\" class=\"lista_bloco\" cellpadding=0 cellspacing=0>	
				$html_user
			</table>
		</div>	
	</div>	"
	
	
	
	append html "<div class=\"block\">
					<div class=\"tblock\">Resultados por Rede  (Período $min_date - $max_date) </div>
					<div class=\"cblock\">
						<table clear=\"all\" border=\"0\" class=\"lista_bloco\" cellpadding=0 cellspacing=0>	
							$html_rede
						</table>
					</div>
				</div>
			</div>
			<div class=\"footer\">
				
			</div>
			</div> <!-- fecha o ctn all-->
		</div> <!-- fecha o content-->
	</body>
</html>
"

if {1} {


set filename_base [ns_mktemp "/tmp/htmlXXXXXX"]
set filename_base "${filename_base}.html"
set fd [open $filename_base w]

#set html	[encoding convertfrom utf-8  $html]

set filename_bs [ns_mktemp "/tmp/pdfXXXX"]
set filename_pdf "${filename_bs}.pdf"
set filename_pdf "/tmp/teste7.pdf"

ns_log notice "file names $filename_pdf  $filename_base     ${filename_bs}.pdf"
puts $fd $html
#	puts $fd $footer

close $fd

ns_log notice "close fd" 
ns_log notice "passou iconv |  exec /usr/bin/pisa/wkhtmltopdf $filename_base $filename_pdf" 
# if [catch {exec htmldoc --firstpage toc --size 210x297mm --left 1cm --right 1.5cm --webpage --quiet -f $filename_pdf $filename_base2 -} errmsg]

if {[catch {exec /usr/bin/pisa/wkhtmltopdf-i386 $filename_base $filename_pdf  } errmsg]} {
	ns_log notice "ERRO: $errmsg"   	    
    if { $errmsg eq "child process exited abnormally" || 1} {
     	ns_set update [ns_conn outputheaders] Content-Disposition "attachment; filename=\"relatorio-planeta-$account_name-[ad_generate_random_string 5].pdf\""
       	ns_returnfile 200 application/pdf $filename_pdf
    } else {
		set report_content $errmsg
    }

} else {

ns_log notice "nao deu erro"
    ns_log debug "DAVEB: download_filename='$filename_pdf'"
 	ns_set update [ns_conn outputheaders] Content-Disposition "attachment; filename=\"relatorio-planeta-$account_name-[ad_generate_random_string 5].pdf\""
 	 	ns_log notice "vai retornar"
 	ns_returnfile 200 application/pdf $filename_pdf
 	ns_log notice "vai abortar"
    ad_script_abort
    
}
 	ns_log notice "vai abortar 2"
ad_script_abort

}
