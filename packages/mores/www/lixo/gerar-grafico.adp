<link rel="stylesheet" type="text/css" href="mores.css" /> 
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

#search_facebook {margin-left:-155px;margin-top:-140px}
.socialmention {float:left}

#socialmention_buzz_iframe_1 {
	width:100% !important;
}

.socialmention-buzz-widget .item .text {
	margin-left: 50px ;
}

</style>

<div  class="socialmention-buzz-widget clearfix" id="socialmention_buzz_1942">
	<h1> Planeta MPI<h1>
	<h2>Relatório do Monitoramento do Concurso da Embratur </h2>
	<form action="ver-relatorio-mpi">
	Redes:<select name="sources" id="sources">
		<option value="">Todas</option>
	<multiple name="redes">
		<option value="@redes.source@">@redes.source@ - @redes.qtd@ menções</option>
	</multiple>
	</select>
	<br />

	Tipo de Gráfico: <select name="grafico" id="grafico">
		<option value="Area">Área</option> 
		<option value="Line">Linha</option> 
		<option selected=selected value="Bar">Barras</option> 
	</select>
	<br/>

	Data inicial: <input type="text" id="datai" name="datai" value="2010-11-20">
	<br/>
	Data final: <input type="text" id="dataf" name="dataf" value="">

	<br/>
	Limite: <input type="text" id="limite" name="limite" value="500">

	<br/>

	</select>
	<br />

	Filtrado?: <select name="filter" id="filter">
		<option value="1">Filtrado com a palavra "Embratur"</option> 
		<option value="0">Sem Filtro</option> 
	</select>
	<input type="submit" value="Gerar gráfico">


	</form>
</div>
