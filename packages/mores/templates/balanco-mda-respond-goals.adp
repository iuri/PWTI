<style type="text/css">

*{margin:5; padding:0; }
#table{width:100%; height:100%;  font-family:Arial, Helvetica, sans-serif; font-size:14px; color:#000000;}
.box{width:960px; background-color:#ffffff; border:1px solid #E4E4E4;}
.box p{ font-family:"trebuchet MS", arial; font-size:24px; padding:10px 0 0 15px; color:#000000;}
#dados { width:770px; background:#FFFFFF; position:relative; bottom:15px; left:8px; width:920px; height:170px;overflow:scroll;}
.style1 {font-family:Arial, Helvetica, sans-serif; font-size:20px; color:#235C96;}
.title{color: #FFFFFF; font-family:Arial, Helvetica, sans-serif; font-size:14px;}
.sub-title{color: #4c4c4c; font-family:Arial, Helvetica, sans-serif; font-size:14px;}
.botao-nav{border:1px solid #CCCCCC;color:#333333;font:13px Arial,Helvetica,sans-serif;padding:4px;}
.titulo{font-family:Arial, Helvetica, sans-serif; font-size:20px; color:#235C96;}
.sub-titulo{font-family:Arial, Helvetica, sans-serif; font-size:16px; color:#666666; font-weight:bold;}
.texto { font-family:Arial, Helvetica, sans-serif; font-size:14px; color:#666666; line-height:20px; padding:0 0 0 2px;}
.sub-texto { font-family:Arial, Helvetica, sans-serif; font-size:20px; color:#666666; padding:0 0 0 2px;}
.style2 {font-size:20px; font-family: Arial, Helvetica, sans-serif;}
.respondido03  {background:none repeat scroll 0 0 #FFFFFF;border-bottom:#FFFFFF;}
.nav-list {margin-bottom:-2px;}
textarea  {border:1px solid #CCCCCC;color:#787878;font:13px Arial,Helvetica,sans-serif;margin-left:5px;padding:2px;}
</style>
<p>
			<span style="color: rgb(153, 153, 153); font-size: 2.45em; font-weight: bold; letter-spacing: -0.9px; margin-right: 3px;">
				Clique nos botões abaixo para informar os dados qualitativos e quantitativos da ação @current_action@.
			</span> 
	</p>
	<ul  class="nav-list">
		<li style="display:inline;"><input class="botao-nav respondido03" type=button id="link_titleActionTexto" value="Dados Qualitativos" /> </li>
		<li style="display:inline;"><input type=button class="botao-nav" id="link_financeiro" value="Financeiro"/> </li>
		<multiple name=lista_variaveis>
			<li style="display:inline;"><input type=button class="botao-nav" id="link_@lista_variaveis.territory_step_id@" value="@lista_variaveis.name@"/> </li>
		</multiple>
	</ul>



	
	<div  class="desativado box" id="titleActionTexto">	
		<formtemplate id="execution">
				@ams_html;noquote@
			 <input type="hidden" name="territory_action_id_p"  id="territory_action_id_p"  value="@territory_action_id_p@" />
       	<input type="hidden" name="territory_matrix_id_p"  id="territory_matrix_id_p"  value="@territory_matrix_id_p@" />
		<p class="botaoEnviar"><input type="submit" class="btEnviarResposta" value="Salvar dados Qualitativos" id="btEnviarRespostaTexto"></p> 
		</formtemplate>

	</div>	



	<div id="titleActionFinanceiro"  style="display:none;">		
	   <form id="form_financeiro" action="balanco-mda-process-execution-ajax">
	    <input type="hidden" name="territory_action_id_p"  id="territory_action_id_p"  value="@territory_action_id_p@" />
		<input type="hidden" name="territory_matrix_id_p"  id="territory_matrix_id_p"  value="@territory_matrix_id_p@" />
		<input type="hidden" name="territory_step_id_p"  id="territory_step_id_p"  value="0" />
		<input type="hidden" name="step_name"  id="step_name"  value="Financeiro" />

		<div class="desativado box" id="questionarioAcaofinanceiro">
			<div class="titulo"><br/>Financeiro</div> <br />
			<div class="sub-texto">Para inserir os dados basta seguir os passos abaixo:</div> <br />
			<div class="texto">
				1 - Obtenha o arquivo modelo <a class="bt_execucao"  href="file-goals?territory_action_id_p=@territory_action_id@&territory_step_id_p=0">clicando aqui</a> e salve o arquivo no seu computador.<br/>
				2 - Preencha a planilha com os dados requeridos. (quando não houver o dado, digite o número 0 na célula correspondente)<br/>
				3 - Selecione os dados da planilha (todas as colunas e todas as linhas, exceto a primeira linha - cabeçalho)<br/>
				4 - Copie e cole no campo abaixo os dados<br/>
				5 - Pressione o botão "Preencher campos"<br />
				6 - Confira os dados e em seguida clique em salvar.
			</div>		
					<br/>
					<br/>
				<br/><textarea rows="4" cols="120" id="origemDadosfinanceiro" onkeyup="preenche('origemDadosfinanceiro',1,'financeiro');"/></textarea>
				<input type="button" onclick="preenche('origemDadosfinanceiro',1,'financeiro');" value="Preencher campos">
			</p>
			<br/><br/><br/>
			  <div id="dados">
				<table width="760" border="0" align="center" cellpadding="2" cellspacing="2">
					<tr> 
						<td align="center" bgcolor="#4c4c4c" class="title">Ano</td>
						<multiple name=lista_matrix>
							<td align="center" bgcolor="#4c4c4c" class="title">@lista_matrix.matrix_name@</td>
						</multiple>
					</tr>					
					<tr>
						<multiple name=lista_dados_financeiros>
							<tr>
								<td height="25" align="center" bgcolor="#CCCCCC" class="sub-title">@lista_dados_financeiros.location_name@</td>
								<group column="location_name">
									<td align="center" bgcolor="#f7f7f7">
										<input type="text" value="@lista_dados_financeiros.paid@" name="financeiro.@lista_dados_financeiros.territory_matrix_id@.@lista_dados_financeiros.location_name@"  id="financeiro.@lista_dados_financeiros.territory_matrix_id@.@lista_dados_financeiros.location_name@"size="8" />
									</td>
								</group>
							</tr>
						</multiple>
					</tr>
				</table>
			</div>
		</div>

		</form>
		<form  method="post" id="form_send_financeiro">
			<p class="botaoEnviar"><input type="submit" class="btEnviarResposta" value="Salvar dados Financeiros" id="btEnviarRespostaFinanceiro"></p> 
		</form>
	</div>

	<multiple name=lista_dados>
		<div  id="titleAction@lista_dados.territory_step_id@"  style="display:none;">
	   		<form id="form_@lista_dados.territory_step_id@" action="balanco-mda-process-execution-ajax">		
		   		<input type="hidden" name="territory_action_id_p"  id="territory_action_id_p"  value="@territory_action_id_p@" />
				<input type="hidden" name="territory_matrix_id_p"  id="territory_matrix_id_p"  value="@territory_matrix_id_p@" />
				<input type="hidden" name="territory_step_id_p"  id="territory_step_id_p"  value="@lista_dados.territory_step_id@" />
				<input type="hidden" name="step_name"  id="step_name"  value="@lista_dados.step_name@" />
				<div class="desativado box" id="questionarioAcao@lista_dados.step_name@">
				<div class="titulo"><br/>@lista_dados.step_name@</div> <br />
					<div class="sub-texto">Para inserir os dados basta seguir os passos abaixo:</div> <br />
					<div class="texto">
					1 - Obtenha o arquivo modelo <a class="bt_execucao"  href="file-goals?territory_action_id_p=@territory_action_id@&territory_step_id_p=0">clicando aqui</a> e salve o arquivo no seu computador.<br/>
					2 - Preencha a planilha com os dados requeridos. (quando não houver o dado, digite o número 0 na célula correspondente)<br/>
					3 - Selecione os dados da planilha (todas as colunas e todas as linhas, exceto a primeira linha - cabeçalho)<br/>
					4 - Copie e cole no campo abaixo os dados<br/>
					5 - Pressione o botão "Preencher campos"<br />
					6 - Confira os dados e em seguida clique em salvar.
				</div>		
					<br/>
					<br/>
					<br/><textarea rows="4" cols="120" id="origemDados@lista_dados.territory_step_id@" onkeyup="preenche('origemDados@lista_dados.territory_step_id@',0,@lista_dados.territory_step_id@);"/></textarea>
					<input type="button" onclick="preenche('origemDados@lista_dados.territory_step_id@',0,@lista_dados.territory_step_id@);" value="Preencher campos">
				</p>
				<br/><br/><br/>
					  <div id="dados">
						<table width="760" border="0" align="center" cellpadding="2" cellspacing="2">
						<tr> 
							<td align="center" bgcolor="#4c4c4c" class="title">Ano</td>
							<multiple name=lista_matrix>
								<td align="center" bgcolor="#4c4c4c" class="title">@lista_matrix.matrix_name@</td>
							</multiple>
						</tr>
						<group column="step_name">
							<tr>
								<td height="25" align="center" bgcolor="#CCCCCC" class="sub-title">@lista_dados.location_name@</td>
								<group column="location_name">
									<td align="center" bgcolor="#f7f7f7">
										<input type="text" value="@lista_dados.executed@" name="fisico.@lista_dados.territory_matrix_id@.@lista_dados.location_name@.@lista_dados.territory_step_id@"  id="fisico.@lista_dados.territory_matrix_id@.@lista_dados.location_name@.@lista_dados.territory_step_id@"size="8" />
									</td>
								</group>
							</tr>
						</group>
					</table>
					</div>

				</div>

			</form>
			<form  method="post" id="form_send_@lista_dados.territory_step_id@">
				<p class="botaoEnviar"><input type="submit" class="btEnviarResposta" value="Salvar dados de @lista_dados.step_name@" id="btEnviarResposta@lista_dados.territory_step_id@"></p> 
		    </form>
		</div>
	</multiple>
	<!-- end of form -->


