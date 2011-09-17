<master src="/www/blank-compat">
  <property name="title">@title@</property>
  <property name="header_stuff">
    @header_stuff;noquote@
  </property>
  <if @context@ not nil><property name="context">@context;noquote@</property></if>
    <else><if @context_bar@ not nil><property name="context_bar">@context_bar;noquote@</property></if></else>
  <if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
  <if @doc_type@ not nil><property name="doc_type">@doc_type;noquote@</property></if>
     <if @untrusted_user_id@ ne 0>
    </if>
    <else>
    </else>


<div class="wrap">
	<div class="government_bar">
		<p class="logo"><a href="http://www.brasil.gov.br" title="">Acessar o site do Governo Federal</a></p>
	</div>
	<div class="menu">
		<ul>

			<li><a href="@subsite_url@" title="Página Inicial">Página Principal</a></li>
			<li><a href="/arcoverde/pages/oprograma" title="Sobre o programa">Sobre o programa</a></li>
			<li><a href="/arcoverde/noticias/" title="Noticias do Programa">Notícias do Programa</a></li>

			<if @untrusted_user_id@ eq 0>
				<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
			</if>
			<else>
					<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
			</else>
	
		</ul>
	</div>
	
	<if @subsite_admin_p@>
	<div class="menu">
	<ul>
				<if @sw_admin_p@>
						<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
				</if>

				<if @subsite_admin_p@>
			   		<multiple name="applications">
							<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a>
								<if @applications.available@ not nil>
									 <a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">Add portlet Application</a>
								</if>
							</li>
					</multiple>
				</if>
			</ul>
	</div>
	</if>


	<div class="header">
		<p class="site name"><a href="@subsite_url@" title="Voltar para página principal">Mutirão Arco Verde Terra Legal</a></p>
		<div class="animation">

			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="1008" height="350">
				<param name="movie" value="/resources/theme-mda/swf/arcoverde/animacao_arco_verde.swf" />
				<param name="quality" value="high" />
				<param name="wmode" value="transparent" />
				<embed src="/resources/theme-mda/swf/arcoverde/animacao_arco_verde.swf" wmode="transparent" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="1008" height="350"></embed>
			</object>
		</div>
		
		<div class="search">
			<form action="http://www.google.com/cse" id="cse-search-box">
				<p><span class="txt_search">Buscar no site:</span><input type="hidden" name="cx" value="006027766869131785344:mg88hxlpgok" /><input type="hidden" name="ie" value="UTF-8" /><input type="text" name="q" class="txtfield" /><input type="submit" name="sa" value="Buscar" class="bt_search" /></p>
			</form>
			<script type="text/javascript" src="http://www.google.com/jsapi"></script>
			<script type="text/javascript">google.load("elements", "1", {packages: "transliteration"});</script>
			<script type="text/javascript" src="http://www.google.com/coop/cse/t13n?form=cse-search-box&t13n_langs=pt"></script>
			<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=pt"></script>
		</div>

		<if @survey_arcoverde_admin@>
		<div class="survey">
			<a href="/arcoverde/pages/questionario" title=""><img src="/resources/theme-mda/imagens/arcoverde/img_questionary.gif" alt="" /></a>
			<div class="info">
				<h5><a href="/arcoverde/pages/questionario" title="Preencha o Relatório das atividades no município">Preencha o Relatório das atividades no município</a></h5>
				<p><a href="/arcoverde/pages/questionario" title="Preencha o Relatório das atividades no município">Clique aqui para preencher o relatório de atividades desenvolvidas em um município.</a></p>
			</div>
		</div>
		</if>
		<else>
			<div class="survey">
				<a href="/arcoverde/pageflip/pageflip-view?pageflip_id=2345300" title="Revista Arco Verde Terra Legal"><img src="/resources/theme-mda/imagens/arcoverde/img_revista.gif" alt="Revista Arco Verde Terra Legal"/></a>
				<div class="info">
					<h5><a href="/arcoverde/pageflip/pageflip-view2?pageflip_id=2345300" title="Revista Arco Verde Terra Legal">Revista Arco Verde Terra Legal</a></h5>
					<p><a href="/arcoverde/pageflip/pageflip-view2?pageflip_id=2345300" title="Acesse agora a revista do Multirão Arco Verde">Acesse a revista e entenda como a regularização fundiária e a cidadania contribuirão com a implantação de modelos de produção sustentável na Amazônia Legal.</a></p>
				</div>
			</div>
		</else>
	</div>
	<div class="content">

		<if @portal_page_p@ not eq 1>
			<div class="content_text">
			<h2>@title@</h2>
		</if>

		<slave>

		<if @portal_page_p@ not eq 1>
			</div>
		</if>

	</div>

	
	<div class="footer">
		<!-- 
		<ul>
			<li><a href="">Política de privacidade</a></li>
			<li><a href="">Política de acessibilidade</a></li>
		</ul>
		-->
	</div>
	
		<script type="text/javascript">
			var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
			document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
			</script>
		<script type="text/javascript">
				try {
				var pageTracker = _gat._getTracker("UA-9395963-1");
				pageTracker._trackPageview();
			} catch(err) {}
		</script>
</div>




