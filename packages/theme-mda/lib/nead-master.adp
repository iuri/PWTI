<master src="/www/blank-compat">
  <property name="title">@title@</property>
  <property name="header_stuff">
    @header_stuff;noquote@

	<style type="text/css">
		.header {
			background: url("/resources/theme-mda/imagens/nead/topo0@random_top@.jpg") no-repeat scroll right top #FFFFFF;
		}
	</style>


  </property>
  <if @context@ not nil><property name="context">@context;noquote@</property></if>
    <else><if @context_bar@ not nil><property name="context_bar">@context_bar;noquote@</property></if></else>
  <if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
  <if @doc_type@ not nil><property name="doc_type">@doc_type;noquote@</property></if>
     <if @untrusted_user_id@ ne 0>
    </if>
    <else>
    </else>
	<if @random_top@ gt 2>
		<style type="text/css">
			.header .header_menu {
				background-color: #fff;
				
			}
			.header .header_menu ul li a {
				color:#A15502;
			}
		</style>
	</if>





<div class="wrap">
	<iframe width="1008" height="36" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/barragoverno/barra.html"></iframe>
	<div class="header">
		<p class="site name"><a href="#" title="Voltar para página principal"></a></p>
	        <div class="elemento_header"><a href="@subsite_url@" title="NEAD"><img src="/resources/theme-mda/imagens/nead/logo_nead.png" alt="Nead" /></a></div>
	</div>



	<div class="menu_superior">
		<div class="search">
			<fieldset>
         			<form style="float: right; margin-right: 70px; margin-top: 10px;" id="cse-search-box" action="/portal/nead/institucional/busca">
                                                <label for="cse-search-box">Busca:</label>
                                                <input name="cx" value="006027766869131785344:xpaxf63rt6w" type="hidden" />
                                                <input name="cof" value="FORID:10" type="hidden" />
                                                <input name="ie" value="UTF-8" type="hidden" />
                                                <input class="txtfield" name="q" id="buscar" size="31" type="text" />
                                                <input name="sa" value="Buscar" type="submit" class="bt_search"/>
                                   </form>
			</fieldset>
		</div>
	</div>
  	<div class="wrap_content">

   	  <div class="leftcolumn">
				<ul id="menu">
				@horizontal_menu;noquote@
				</ul>
	
				<if @subsite_admin_p@>
				   <div id="admin">
					<ul id="menu">
					<multiple name="applications">
						<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a></li>
						<if @applications.available@ not nil>
							 <li><a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">++</a></li>
						</if>
					</multiple>
					<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
					<if @sw_admin_p@>
						<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
					</if>
					</ul>
				   </div>
				</if>


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


	  <div class="content_home">
			<if @portal_page_p@ eq 0>
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
			</if>
			
			<if @user_messages:rowcount@ gt 0>
		        <div id="alert-message">
	    		    <multiple name="user_messages">
	        		     <div class="alert"><strong>@user_messages.message;noquote@</strong></div>
	            	</multiple>
		        </div>
		     </if>


			<slave>



	  </div>
	</div>
	<div class="footer">
		<div class="info">
			<p class="secretaria">Ministério do Desenvolvimento Agrário - Núcleo de Estudos Agrários e Desenvolvimento Rural</p>
			<address>SBN, QD. 02 Bloco D Lote 16 - Loja 10 - Ed. Sarkis - 2° Subsolo - CEP 70040-910- Sala 2º Subsolo
			 <br />Telefones: (61) 2020 0170 / 2020 0189 </address>
			 <ul>
			 <if @untrusted_user_id@ eq 0>
				<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
		     </if>
		     <else>
				<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
		     </else>
			 </ul>

		</div>

	


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

