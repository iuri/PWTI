<master>
<link rel="stylesheet" type="text/css" href="mores.css" /> 
<script type="text/javascript" src="includes/jquery.js"></script>
<script type="text/javascript" src="includes/json.js"></script>
<script type="text/javascript" src="includes/chartplugin.js"></script>
<script type="text/javascript" src="includes/excanvas.js"></script>
<script type="text/javascript" src="includes/wz_jsgraphics.js"></script>
<script type="text/javascript" src="includes/chart.js"></script>
<script type="text/javascript" src="includes/canvaschartpainter.js"></script>
<script type="text/javascript" src="includes/jgchartpainter.js"></script>
<link rel="stylesheet" type="text/css" href="styles.css" />
<link rel="stylesheet" type="text/css" href="includes/canvaschart.css" />

<script type="text/javascript">
$(document).ready(function()  {
	$('#mychart')
		.chartInit({"painterType":"jsgraphics","backgroundColor":"","textColor":"","axesColor":"","yMin":"0","yMax":"@max_qtd@","xGrid":"0","yGrid":"15","xLabels":[@days@],"showLegend":false})
		.chartAdd({"label":"Menções","type":"@grafico@","color":"#008800","values":[@values@]})
		.chartClear()
		.chartDraw();
});
</script>
<style>
body{
 font:normal 75% normal arial,sans-serif;

} 
ol li{
  padding:10px;
}
pre{
  font-size:160%;
}

h3 img {width:50px;}
h1 {color:#999}
#facebook {width:600px; overflow:hidden;float:left;background-color:fff}
#search_facebook {margin-left:-155px;margin-top:-140px}
.socialmention {float:left}

#socialmention_buzz_iframe_1 {
	width:100% !important;
}
.socialmention-buzz-widget .item .text {
	margin-left: 50px ;
}

</style>

<div style="font-size: 11px;" class="socialmention-buzz-widget clearfix" id="socialmention_buzz_1942">

<h2>Planeta MPI </h2>
<h2>@account_name@</h2>

<div class="left">
<p>Entre <b>@min_date@</b> e <b>@max_date@</b>,  <b>@qtd_total@</b> menções ÚNICAS nas redes sociais tiveram relação com suas palavras-chave.<br /> Elas estão separadas por: <br> 

<div class="bloco">
<h2 class="titulo_bloco">Usuários mais relevantes:</h2>
	
		<table clear="all"  border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
			<multiple name=users>
				<tr><td><a href="http://twitter.com/@users.user_name@" ><b>@@users.user_name@ </b> </a></td> <td> @users.qtd@ menções</td> </tr>
			</multiple>
		</table>
	</div>	
	<br>
	<br>
	<div class="bloco">
		<h2 class="titulo_bloco"><b>Data</b>:</h2>
	
		<table border=1>
			<tr> <td> dia</td>	
				<multiple name="datas">
					<td>@datas.dia@</td>
				</multiple>
			</tr>
			<tr> <td> Qtd_menções</td>	
				<multiple name="datas">
					<td>@datas.qtd@</td>
				</multiple>
			</tr>
		</table>
	</div>	
	<p> </p>


	
	
</div>
	<div class="right">	
	
	<div class="bloco">
	<h2 class="titulo_bloco">Resultados por Termo Monitorado:</h2>

		<table clear="all" border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
			<multiple name=querys>
				<tr><td><b>@querys.query_text@ </b></td> <td> @querys.qtd@ menções</td> </tr>
			</multiple>
		</table>
		</div>
		<br />
		<br />
		
		<div class="bloco">
		<h2 class="titulo_bloco">Resultados por Rede:</h2>

		<table clear="all" border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
			<multiple name=redes>
				<tr><td><b>@redes.source@ </b></td> <td> @redes.qtd@ menções</td> </tr>
			</multiple>
		</table>
		</div>
</div>
<br />



<div id="chartarea">
<h3>Gráfico com a evolução das Menções ao longo do tempo</h3>
<div id="mychart" class="chart" style="width: 900px; height: 300px;"></div>
</div>

<hr>

<!-- <h3>Resultado do Monitoramento: </h2> -->



<div>

