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

	<!-- Inicio Topo -->
	<div id="topo">
		<div id="logo"><a href="@subsite_url@"> <img src="/resources/theme-mda/imagens/conjur/logo.jpg" alt="Consultoria Jurídica Junto ao Ministério do Desenvolvimento Agrário" border="0"/></a> </div> 
		<!-- <div class="search" >
			<p ><span class="txt_search"></span> <input name="" type="text" class="txtfield" /> <input name="" value="Buscar" type="button" class="bt_search" /></p>
		</div> -->
	</div>


	<!-- Fim Topo -->   

	<!-- Inicio Menu -->
	<div id="menu_navegacao">
      		<ul>
			@horizontal_menu;noquote@
			<if @untrusted_user_id@ eq 0>
				<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
			</if>
			<else>
				<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
			</else>
      		</ul>
    	</div>
    	<!-- Fim Menu -->
	
	<!-- Inicio menu admin -->
	<if @subsite_admin_p@>
		<div id="menu_navegacao">
			<ul>
				<multiple name="applications">
					<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a>
					<if @applications.available@ not nil>
						 <a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">++</a>
					</if>
					</li>
				</multiple>
					<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
					<if @sw_admin_p@>
						<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
					</if>
					<li class="ativo"><a href="@subsite_url@/admin/menus/choose-parent">Tornar esta página um item de menu</a></a>
			    </ul>
					
    		</div>
	</if>
    	<!-- Fim menu admin -->


	<if @portal_page_p@>
		<div class="content_home">
	</if>
	<else>
		<div class="content">
			<div class="titulo">
				<h1>@page_title@</h1>
					<!-- <div class="breadcrumbs">
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
						</if>
					</div> -->
				</div>
	</else>
		<slave>
	</div>



<div id="footer">
	<div id="banners">
		<include src="/packages/banners/templates/banners-portlet" package_id="@banners_package_id@">
  	</div>
	<p> Consultoria Jurídica Junto ao Ministério do Desenvolvimento Agrário</p>
	<address>Setor Bancário Norte &ndash; Qd. 01 &ndash; BL D - Palácio do Desenvolvimento &ndash; 06º andar <br>
	CEP 70057-900 &ndash; Brasília &ndash; DF - Telefone: (61) 2020-0910 fax: (61) 2107-0909 </address>
</div>
</div>







<script type="text/javascript" language="Javascript" src="http://www.google-analytics.com/urchin.js"></script>
<script type="text/javascript" language="Javascript">
<!--
	_uacct = "UA-2291113-2";
	urchinTracker();
-->

</script>

