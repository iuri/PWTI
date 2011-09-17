<link rel="stylesheet" type="text/css" href="mores.css" /> 
<link rel="stylesheet" type="text/css" href="styles.css" />

<script type="text/javascript" src="/resources/mores/js/jscharts.js"></script>

<style>
.relatorio{
 font:normal 150% normal arial,sans-serif;

} 
ol li{
  padding:10px;
}
pre{
  font-size:160%;
}

h3 img {width:50px;}



#relatorio {
margin: 0 auto;
    width: 1024px;
}

h2 {
    color: #3333EE !important;
 background: none repeat scroll 0 0 #EEEEEE;
}
.right {
    float: left;
    margin-bottom: 54px;
    width: 26%;
    }
.bloco {
 background: none repeat scroll 0 0 #CDCDCD;
}

.lista_bloco {
    font-size: 90%;
    padding: 10px;
    width: 100%;}
    

</style>

<div id="relatorio"> 
	<p align="center">
		<h2> Relatório do Planeta MPI  - Período @min_date@ - @max_date@</h2>
		<br >
		<h3> Relatório do Monitoramento nas Redes Sociais: @account_name@  </h3>
	</p>
<br /> 
<hr />

		
	<div class="relatorio">
	
		<table>
		<tr>
		<td>
			<br />
			<br />
			<br />
			<ul>
				<li style="margin-top: 15px;"> <b>Termo Monitorado: </b>@termo@ <br /></li>
				<li style="margin-top: 15px;"> <b>Período Avaliado: </b>@min_date@ a @max_date@ <br /></li>
				<li style="margin-top: 15px;"> <b>Menções nas Redes: </b>@qtd_total@ <br /></li>
				<li style="margin-top: 15px;"> <b>Total de Usuários que mencionaram: </b>@qtd_users@ <br /></li>
				<li style="margin-top: 15px;"> <b>Total de Redes com menções: </b>@qtd_rede@ </li>

			</ul>
		</td>
		<td>
		
		<br /> 
		<br /> 

			<div id="graph-sent" style="overflow: hidden; width: 487px;">Loading graph...</div>

			<script type="text/javascript">
				var myData = new Array(@value_query@);
				var colors = ['#00FF00','#FF0000',  '#00FFFF', '#0000FF'];
				var myChart = new JSChart('graph-sent', 'pie');
				myChart.setDataArray(myData);
				myChart.colorizePie(colors);
				myChart.setTitle('Análise do Sentimento nas Redes(%)');
				myChart.setTitleColor('#000000');
				myChart.setTitleFontSize(11);
				myChart.setTextPaddingTop(30);
				myChart.setSize(616, 321);
				myChart.setPiePosition(308, 170);
				myChart.setPieRadius(85);
				myChart.setPieUnitsColor('#000000');
				myChart.setBackgroundImage('/resources/mores/chart_bg2.jpg');
				myChart.draw();
			</script>
	

	</td>
	</tr>
	</table>
	</div>
<br /> <br /> <br /> 
<hr />
	<h2 class="titulo_bloco">Menções nas redes por dia (Período @min_date@ - @max_date@)</h2>
	<div id="graph"  style="overflow: hidden; width: 1000px;">Loading graph...</div>

	<script type="text/javascript">
		var myChart = new JSChart('graph', 'line');
		//myChart.setDataArray(myData);
		@xml_dados@
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
		myChart.setBackgroundImage('/resources/mores/chart_bg.jpg');
		myChart.draw();
	</script>
	<br /> 
	<br /> 

	
	
<hr />	
		<h2 class="titulo_bloco">Menções nas redes por Hora  (Período @min_date@ - @max_date@)</h2>
	<div id="graph-hora" style="overflow: hidden; width: 1000px;">Loading graph...</div>

	<script type="text/javascript">
		var myChart = new JSChart('graph-hora', 'line');
		//myChart.setDataArray(myData);
		@xml_dados_hora@
		myChart.setTitle('Total de Menções / HORA');
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
		myChart.setBackgroundImage('/resources/mores/chart_bg.jpg');
		myChart.draw();
	</script>
	<br /> 
	<br /> <br /> 
	

		<hr />
		<div class="bloco relatorio">
		<h2 class="titulo_bloco">Usuários mais relevantes:</h2>
	
				<table clear="all"  border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
					<multiple name=users>
						<tr style="height: 28px;"><td><a href="http://twitter.com/@users.user_name@" ><b>@@users.user_name@ </b> </a> </td><td> http://twitter.com/@users.user_name@ </td> <td> @users.qtd@ menções</td> </tr>
					</multiple>
				</table>
			</div>	
			<br>
			<br>

			<p> </p>
			<br /> 

	<hr />
		<if @query_id_p@ eq "">

		<div class="bloco  relatorio">
			<h2 class="titulo_bloco">Resultados por Termo Monitorado  (Período @min_date@ - @max_date@)</h2>

				<table clear="all" border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
					<multiple name=querys>
						<tr style="height: 28px;"><td><b>@querys.query_text@ </b></td> <td> @querys.qtd@ menções</td> </tr>
					</multiple>
				</table>
				</div>
				<br />
				<br />
				<br /> 
	<hr />	
		</if>
			<div class="bloco  relatorio">
				<h2 class="titulo_bloco">Resultados por Rede  (Período @min_date@ - @max_date@)</h2>

				<table clear="all" border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
					<multiple name=redes>
						<tr style="height: 28px;"><td><b>@redes.source@ </b></td> <td> @redes.qtd@ menções</td> </tr>
					</multiple>
				</table>
			</div>

		<br />



		<hr>

		<!-- <h3>Resultado do Monitoramento: </h2> -->


</div>



