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
		<iframe width="1007" height="36" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/barragoverno/barra.html"></iframe>
	<div class="header">
		<p class="site name"><a href="@subsite_url@" title="Voltar para página principal">@subsite_info.instance_name@</a></p>
		<div class="elemento_header"></div>
		<div class="search">
  			<form id="cse-search-box" action="@subsite_url@institucional/busca">
			<fieldset>
				<label for="buscar">Buscar:</label>
				<input name="cx" value="006027766869131785344:ythqh-jrkhc" type="hidden" /> 
				<input name="cof" value="FORID:10" type="hidden" />

				<input name="ie" value="UTF-8" type="hidden" /> 

				<input name="q" id="buscar" type="text"  class="txtfield" />
				<input name="buscar" id="buscar" value="Buscar" class="bt_buscar" type="submit" />
			</fieldset>
			</form>
		</div> 
		<div class="header_menu">
			<ul>

				<!-- <li><a href="#" title="Busca Avançada">busca avançada</a></li> -->
				<li><a href="https://mail.mda.gov.br/mdawebmail/src/login.php" title="Webmail" target="_blank">webmail</a></li>
				<li><a href="@subsite_url@/institucional/faleconosco" title="Fale Conosco">fale conosco</a></li>
				<!-- <li><a href="#" title="Mapa do Site">mapa do site</a></li> -->
				<if @untrusted_user_id@ eq 0>
					<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
				</if>
				<else>
					<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
				</else>
	
				<li class="outras_opcoes"><a href="#" title="Outras opções">Outras opções</a></li>
			</ul>
		</div>
	</div>
	<div class="menu_horizontal">
		<ul>
			@horizontal_menu;noquote@
		</ul>
	</div>
	<div class="wrap_content">
		<div class="column">
			<div class="menu">
				<ul id="menu">
					@vertical_menu;noquote@
				</ul>
					<if @subsite_admin_p@>
					<h3>#acs-subsite.Administrator#</h3>
						<ul>
						<multiple name="applications">
							<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a>
								<if @applications.available@ not nil>
									 <a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">Add portlet Application</a>
								</if>
							</li>
						</multiple>
						<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
						<if @sw_admin_p@>
							<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
						</if>
					    </ul>
					
					</if>
			</div>
		
		 <include src="/packages/theme-mda/lib/layouts/mda5-2"
	            element_list="@element_list@"
	            element_src="@element_src@"
	            theme_id=@portal.theme_id@
	            portal_id=@portal.portal_id@
	            edit_p="f"
	    	    hide_links_p="f"
	            page_id=@page_id@
	            layout_id=@portal.layout_id@>


           		</div>
		<if @portal_page_p@>
			<div class="content_home">
		</if>
		<else>
			<div class="content">
				<div class="titulo">
					<h1>@page_title@</h1>

					<div class="breadcrumbs">
						<if @context_title:rowcount@ not nil>
							<multiple name="context_title">
										<if @context_title.rownum@ eq @context_title:rowcount@>
											<li class="bread02"><a href="@context_title.url@" title="@context_title.label@">@context_title.label;noquote@</a></li>
										</if>
										<else>
											<li class="bread"><a href="@context_title.url@" title="@context_title.label@">@context_title.label;noquote@</a></li>	
										</else>
							</multiple>
							<li class="ativo">@title;noquote@</li>
							<if @subsite_admin_p@><li class="ativo"><a href="@subsite_url@/admin/menus/choose-parent">Tornar esta página um item de menu</a></a></if>
						</if>
					</div>
				</div>
		</else>
	




			<slave>
		</div>
	</div>
	<div class="footer">
		<div class="info">
			@info_html;noquote@
		</div>
		<!-- 
		<div class="politicas">
			<ul>
				<li><a href="#" title="Política de Acessibilidade">Política de Acessibilidade</a></li>
				<li><a href="#" title="Política de Privacidade">Política de Privacidade</a></li>
			</ul>
		</div>
		-->
	</div>
</div>

<script type="text/javascript">
    var menu=new menu.dd("menu");
    menu.init("menu","menuhover");
</script>
<script type="text/javascript" language="Javascript" src="http://www.google-analytics.com/urchin.js"></script>
<script type="text/javascript" language="Javascript">
<!--
	_uacct = "UA-2291113-2";
	urchinTracker();
-->

</script>

