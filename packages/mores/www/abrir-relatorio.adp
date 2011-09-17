<if @css@>
	<master src="/packages/openacs-default-theme/lib/mores-master">
</if>
<else> 
	<master>
</else>
<link rel="stylesheet" type="text/css" href="mores.css" /> 

<link type="text/css" rel="stylesheet" href="/resources/mores/js/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/resources/mores/js/dhtmlgoodies_calendar.js?random=20060118"></script>
<style type="text/css">
	@extra_css;noquote@
</style>	
<div  class="socialmention-buzz-widget clearfix" id="socialmention_buzz_1942">
	<ul class="compact">
        <li><a class="button" title="Voltar para a Conta" href="account?account_id=@account_id@">Voltar para a Conta</a></li>
    </ul>
	<h2>Relatório do Monitoramento da conta: <b> @account_name@ </b></h2>
	<form action="relatorio-pdf">
		<div style="margin-left:100px;width:39%;float:left;">                 
	Por Termo:<br> <input type="checkbox" value="0" name="query_p" id="q_all" onclick="javascript:preenche_tudo(this, 'query_id_p');" checked="checked"> <label for="q_all">TODAS</label><br>
			<multiple name=querys>
				<input type="checkbox" value="@querys.query_id@" name="query_id_p" id="q@querys.query_id@" checked="checked"><label for="q@querys.query_id@">@querys.query_text@ (@querys.qtd@)</label> <br />
			</multiple>
		<br><br>		 
		 
		 
		 </div>
		 <div>
			Redes:<select name="sources" id="sources">
				<option value="">Todas</option>
			<multiple name="redes">
				<option value="@redes.source@">@redes.source@ - @redes.qtd@ menções</option>
			</multiple>
			</select>
			<br />
			<br />
	 <!--
		Usuários:<select name="users" id="users">
				<option value="">Tod@s</option>
			<multiple name="users">
				<option value="@users.user_name@">@users.user_name@ - @redes.qtd@ menções</option>
			</multiple>
			</select>
			<br/> -->

			<br/>

			Data inicial:<input type="text" value="@min_date@" readonly name="datai" id="datai">
			<input type="button" value="escolha" onclick="displayCalendar(document.forms[0].datai,'yyyy-mm-dd',this)">
			<br/>
			<br/>
			<br/>
			Data final: <input type="text" id="dataf" name="dataf" value="">
			<input type="button" value="escolha " onclick="displayCalendar(document.forms[0].dataf,'yyyy-mm-dd',this)">
			<br/>


			<br/>
	
		<br />
		<input type="hidden" id="account_id" name="account_id" value="@account_id@">
	
			<input type="submit" value="Gerar Relatório em PDF">
	</div>

	</form>
</div>
