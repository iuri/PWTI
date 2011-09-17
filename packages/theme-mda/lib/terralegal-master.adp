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
	<iframe width="1008" height="36" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/barragoverno/barra.html"></iframe>

	<if @subsite_admin_p@>
			<div class="menu_admin">
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
		<p class="site name"><a href="#" title="Voltar para página principal">Terra Legal Amazônia</a></p>
		<div class="animation">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="1008" height="392">
				<param name="movie" value="/resources/theme-mda/swf/terralegal/animacao.swf" />

				<param name="quality" value="high" />
				<param name="wmode" value="transparent" />
				<embed src="/resources/theme-mda/swf/terralegal/animacao.swf" wmode="transparent" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="1008" height="392"></embed>
			</object>
		</div>
	
		<div class="search">
			<form action="http://www.google.com/cse" id="cse-search-box">
				<p><span class="txt_search">Buscar no site:</span><input type="hidden" name="cx" value="006027766869131785344:s4nqu-j_kgm" /><input type="hidden" name="ie" value="UTF-8" /><input type="text" name="q" size="31" class="txtfield" /> <input type="submit" name="sa" value="Buscar" class="bt_search" /></p>
			</form>
			<script type="text/javascript" src="http://www.google.com/jsapi"></script>
			<script type="text/javascript">google.load("elements", "1", {packages: "transliteration"});</script>
			<script type="text/javascript" src="http://www.google.com/coop/cse/t13n?form=cse-search-box&t13n_langs=pt"></script>
			<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=pt"></script>
		</div>

		<div class="menu">
			<ul>
				<li class="home"><a href="@subsite_url@" title="Página Principal">Página principal</a></li>
				<li class="news"><a href="/terralegal/pages/saibamaissobreoprograma" title="Conheça o Terra Legal">Conheça o Terra Legal</a></li>
				<li class="about"><a href="/terralegal/pages/etapasdoprograma" title="Etapas do Programa">Etapas do Programa</a></li>
				<li class="ombudsman"><a href="/terralegal/pages/denuncie" title="Denúncias">Denúncias</a></li>
				<li class="gallery"><a href="/terralegal/pages/imprensa" title="Publicações/Imprensa">Publicações/Imprensa</a></li>
				<li class="list"><a href="/terralegal/dados/aggregator-view?data_id=3292164" title="Posseiros Cadastrados ">Posseiros Cadastrados</a></li>
			</ul>
		</div>
	</div>
	<div class="content">
		<if @user_messages:rowcount@ gt 0>
	        <div id="alert-message">
	          <ul>
	            <multiple name="user_messages">
	              <div class="alert"><strong>@user_messages.message;noquote@</strong></div>
	            </multiple>
	          </ul>
	        </div>
	     </if>
		<if @portal_page_p@ not eq 1>
			<div class="content_text">
			<h3 class="portlet_title">@title@</h3>
		</if>



		<slave>


		<if @portal_page_p@ not eq 1>
			</div>
		</if>
	
	</div>
</div>

<div class="footer">
	<div class="info">
		<p class="name">Ministério do Desenvolvimento Agrário</p>
		<p>Esplanada dos Ministérios, Bloco A / Ala Norte - CEP 70054-900 - Brasília - DF</p>
	</div>
</div>

<script type="text/javascript">
	var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
	try {
		var pageTracker = _gat._getTracker("UA-9395997-1");
		pageTracker._trackPageview();
	} catch(err) {}
</script>




