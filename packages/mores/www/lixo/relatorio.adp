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
 background-color: #F3F2F5;
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

<img src="resources/capa.png" >
<div style="font-size: 11px;" class="socialmention-buzz-widget clearfix" id="socialmention_buzz_1942">

<h2>Planeta MPI </h2>
<h2>Funiversa - Concurso Embratur </h2>


<p>Entre <b>@min_date@</b> e <b>@max_date@</b>,  <b>@qtd_total@</b> menções nas redes sociais tiveram relação com suas palavras-chave.<br /> Elas estão separadas por: <br> 
<b>Palavras monitoradas </b></p>
<ul align="center" class=lista_acoes_roteiro>
		<multiple name=querys>
			<li><a href="monitor?query_id=@querys.query_id@&query_text=@querys.query_text@" > @querys.query_text@ - (@querys.qtd@) menções </a> </li>
		</multiple>
</ul>
<br />
<p>por <b>redes sociais</b> </p>

<ul>
	
<multiple name="redes">
	<li>@redes.source@ 	- @redes.qtd@ menções</li>
</multiple>
</ul>
<br />
<p>por <b>Data</b> </p>

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


<div id="chartarea">
<h3>Gráfico com a evolução das Menções ao longo do tempo</h3>
<div id="mychart" class="chart" style="width: 900px; height: 300px;"></div>
</div>

<hr>

<h3>Resultado do Monitoramento: </h2>


<multiple name="items">
	<h3>@items.date@</h3>
	<group column="date">
		<div class="item" style="">
			<div class="user_image">
				<a target="_blank" href="@items.user_nick@">
					<img src="@items.profile_img@">
				</a>
			</div>
			<div class="text">@items.text@
			</div>
			<div class="details">
				<div class="source">
					<img src="@items.favicon@">&nbsp;
					<span rel="1291660465000" class="date">
						<a target="_blank" href="@items.post_url@" title="Veja o post original ">@items.hora@</a>
					</span>  por <a target="_blank" href="http://twitter.com/@items.user_nick@">@items.user_nick@</a> - @items.source@
				</div>
			</div>
		</div>
	</group>	
</multiple>
<div>

