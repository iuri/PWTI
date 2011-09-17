<if @css@>
	<master src="/packages/openacs-default-theme/lib/mores-master">
</if>
<else> 
	<master>
	<link rel="stylesheet" type="text/css" href="mores.css2" /> 
	<link rel="stylesheet" type="text/css" href="styles.css" />
</else>	

<script type="text/javascript" src="includes/jquery.js"></script>

<div class="ctnAll">
	<div id="left" class="left ctnL">
		<div class="bloco  ctn1">
			<div class="ctn1top wl"></div>
			<div class="ctnLcontent wlctn">
				<h1>@account_name@ </h1>
				<h2> #mores.resumo_atualizado_em# (@updated_at@)</h2>
				<div class="cae mdflt">#mores.selecione_os_filtros_que_desejar#</div>
				<div class="form lista_bloco">
					<form action="account">
						 #mores.Por_termo#: <select id="query_id_p" name="query_id_p" <if @query_id_p@> style="color:red;font-weight:bold;" </if>>
									<option value="">TODAS</option>
									<multiple name=querys>
										<option value="@querys.query_id@" <if @querys.query_id@ eq @query_id_p@> selected="selected" </if> >@querys.query_text@ (@querys.qtd@)</option>
									</multiple>
							</select>
											
						 #mores.por_lingua#: <select id="lang_p" name="lang_p" <if @lang_p@> style="color:red;font-weight:bold;" </if>>
								<option value="todas">TODAS</option>
								<multiple name=langs>
									<option value="@langs.lang@" <if @langs.lang@ eq @lang_p@> selected="selected" </if> >@langs.lang@ (@langs.qtd@)</option>
								</multiple>
						</select> 
						<input type="hidden" id="account_id" name="account_id" value ="@account_id@"  >
						<input type="submit" value ="#mores.filtrar#"  >
					</form>
				</div>	
				<div class="cae mdflt">#mores.entre# <b>@min_date@</b> #mores.e# <b>@max_date@</b>,  <b>@qtd_total@ #mores.mencoes_unicas# </b>#mores.nas_redes_sociais_relacionados_aos_termos#.</div>	
			</div>	
			<div class="ctnbotton"></div>
		</div>
		<div class="bloco  ctn2">
			<div class="ctn2top wl">#mores.Buscas# (#mores.clique_para_abrir_o_planeta#) <if @admin_p@ eq 1> <a href="query?account_id=@account_id@"> #mores.Administrar_termos# </a> </if> </div>
			<div class="ctnLcontent wlctn">
				<ul class="tags">
					<multiple name=querys>
						<li><a target="_blank" class="link" href="monitor?query_id=@querys.query_id@&query_text=@querys.query_text@&account_id=@account_id@" > @querys.query_text@ (@querys.qtd@) </a> </li>
					</multiple>
				</ul>
				<if @admin_geral@ eq 1> 
					<div class="cae mdflt">
						<a  href="query-ae?account_id=@account_id@" class="newtag link">#mores.cadastrar_nova_hashtag#</a>
					</div>
				</if> 
				
			</div>	
			<div class="ctnbotton"></div>
		</div>	

		<div class="bloco ctn2">
			<div class="ctn2top wl">Usuários Mais Ativos </div>
			<div id="chartarea" class="ctnLcontent wlctn">
				<table clear="all"  border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
					<multiple name=users>
						<tr>
							<td><b>@users.user_name@ </b></td>
							<td><a target="_blank" href="http://twitter.com/@users.user_name@" ><b>http://twitter.com/@users.user_name@ </b> </a></td>
						 	<td> <a target="_blank"  href="sentimento-manual?@export_vars;noquote@&user=@users.user_name@">@users.qtd@ #mores.mencoes# </a></td> 
						 </tr>
					</multiple>
				</table>			
			</div> 
		</div> <!-- end bloco grafico -->	
		
		
		<div class="bloco ctn2">
			<div class="ctn2top wl">Usuários Mais Ativos </div>
			<div id="chartarea" class="ctnLcontent wlctn">
				<table clear="all"  border="0" class="lista_bloco" cellpadding=0 cellspacing=0>	
					<multiple name=users>
						<tr><td><a target="_blank" href="http://twitter.com/@users.user_name@" ><b>@@users.user_name@ </b> </a></td>
						 <td> <a target="_blank"  href="sentimento-manual?@export_vars;noquote@&user=@users.user_name@">@users.qtd@ #mores.mencoes# </a></td> </tr>
					</multiple>
				</table>			
			</div> 
		</div> <!-- end bloco grafico -->	

	</div>

	<div id="right" class="right ctnR">

		<div class="bloco ctnR1 first">
			<div class="ctnR1top wr">#mores.Analise_de_sentimento#</div>
			<div class="ctnRcontent wrctn lista_bloco">		</div>
			<div class="ctnRbotton wr">						</div>
		</div>
	</div>	
	<div class="bloco ctnR1">
			<div class="ctnR1top wr">Palavras mais mencionadas:</div>
			<div class="ctnRbotton wr"></div>
	</div>
	<div class="bloco ctnR1">
			<div class="ctnR1top wr">#mores.usuarios_ativos#:</div>
			<div style="background:#fff;padding:10px; max-height: 264px;overflow-y: scroll;width: 244px;">
					
				</div>
				<div class="ctnRbotton wr"></div>
			</div>
	</div>
</div>

		

