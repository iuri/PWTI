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
	
set html "<html lang=\"pt\" xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:v=\"urn:schemas-microsoft-com:vml\">
<head>
<title>Portal da Cidadania</title>
	<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"/>
</head>
<body>"

append html "<h2>Planeta MPI </h2>
<h2>$account_name</h2>"


if {$sources != "" && [string length $sources] < 15} {
	set sql_source " and source = '$sources'"
} else {
	set sql_source ""
}

if {$query_id_p == "" } {
set texto_topo "Gráfico de "
	set sql_query_id ""
	set sql_query_id2 ""
	db_multirow redes select_redes "SELECT source, qtd
		  FROM mores_stat_source
		  where account_id = :account_id $sql_source
		  order by qtd desc
  	 " {
	}

} else {
	set sql_query_id " and query_id = $query_id_p"
	set sql_query_id2 " and maq.query_id = $query_id_p"
	db_multirow redes select_redes "SELECT source, qtd
		  FROM mores_stat_source_query
		  where account_id = :account_id and query_id = :query_id_p $sql_source
		  order by qtd desc
  	" {
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
   
 set qtd_rede 0
db_multirow redes select_redes "SELECT source, qtd
		  FROM mores_stat_source
		  where account_id = :account_id
		  order by qtd desc
  		   ;
  		   " {
  		   incr qtd_rede
} 
set qtd_users [db_string select_name "select count(*) from (SELECT distinct user_id FROM mores_stat_twt_usr  where account_id = :account_id) as tabela;" -default "0"]

set qtd_total [db_string select_name "SELECT sum(qtd)  FROM mores_stat_source  where account_id = :account_id;" -default "0"]


set max_date [db_string select_name "SELECT  to_char(max(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id " -default ""]

set min_date [db_string select_name "SELECT  to_char(min(date), 'DD/MM/YYYY') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id" -default ""]
		

 
   
   
   

append html "
<script type=\"text/javascript\" src=\"http://localhost:8001/resources/mores/js/jscharts.js\"></script>

<div id=\"graph\">Loading graph...</div>

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
	myChart.setAxisValuesNumberX(6);
	myChart.setGraphExtend(true);
	myChart.setGridColor('#c2c2c2');
	myChart.setLineWidth(2);
	myChart.setLineColor('#FF0000', 'red');
	myChart.setLineColor('#FF0000', 'yellow');
	myChart.setSize(1015, 321);
	myChart.setBackgroundImage('http://localhost:8001/resources/mores/chart_bg.jpg');
	myChart.draw();
</script>
<br /> 

<div class=\"relatorio\">
	<div class=\"left\" style=\"float: left;width: 45%;\">
		<br />
		<br />
		<br />
		<ul>
			<li> <b>Período Avaliado: </b>$min_date a $max_date <br /></li>
			<li> <b>Menções Únicas nas Redes: </b>$qtd_total@ <br /></li>
			<li> <b>Total de Usuários que mencionaram: </b>$qtd_users <br /></li>
			<li> <b>Total de Redes com menções: </b>$qtd_rede </li>

		</ul>
	</div>
	</body>
	</html>
	"
	
	
	
set filename_base [ns_mktemp "/tmp/htmlXXXXXX"]
set filename_base "${filename_base}.html"
set fd [open $filename_base w]

set html	[encoding convertfrom utf-8  $html]

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

if {[catch {exec /usr/bin/pisa/wkhtmltopdf $filename_base $filename_pdf  } errmsg]} {
	ns_log notice "ERRO: $errmsg"   	    
    if { $errmsg eq "child process exited abnormally" || 1} {
       	ns_returnfile 200 application/pdf $filename_pdf
    } else {
		set report_content $errmsg
    }

} else {

ns_log notice "nao deu erro"
    ns_log debug "DAVEB: download_filename='$filename_pdf'"
 	ns_set update [ns_conn outputheaders] Content-Disposition "attachment; filename=\"relatorio-planeta-[ad_generate_random_string 5].pdf\""
 	 	ns_log notice "vai retornar"
 	ns_returnfile 200 application/pdf $filename_pdf
 	ns_log notice "vai abortar"
    ad_script_abort
    
}
 	ns_log notice "vai abortar 2"
ad_script_abort
