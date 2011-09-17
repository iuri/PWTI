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
  </if>

<div class="wrap">
	<div class="logo">
	      <div style="position: relative;">#theme-mda.REAF_Menu_topo#</div>
		  <map name="Map">
			  <area shape="rect" href="@subsite_url@" coords="29,13,372,91" />
			  <area shape="rect" href="/acs-lang/change-locale?user_locale=pt_BR&return_url=@return_url@" coords="612,4,632,19" />
			  <area shape="rect" href="/acs-lang/change-locale?user_locale=es_ES&return_url=@return_url@" coords="586,4,607,20" />
			  <area shape="rect" href="@subsite_url@sobre/contatos" coords="875,77,1000,104" />
			  <area shape="rect" href="@subsite_url@register/?return_url=/dotlrn/clubs/reaf/" coords="749,78,873,104" />
			  <area shape="rect" href="@subsite_url@noticias" coords="623,80,747,104" />
			  <area shape="rect" href="@subsite_url@sobre/busca" coords="497,78,621,104" />
		  </map>
	</div>

	<div class="topo">
	    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" height="128" width="100%">
        	<param name="movie" value="/resources/theme-mda/imagens/reaf/banner_principal.swf">
	        <param name="quality" value="high">
	        <param name="wmode" value="transparent">
	        <embed src="/resources/theme-mda/imagens/reaf/banner_principal.swf" quality="high" wmode="transparent" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" height="128" width="100%">
    	</object>
	</div>
	<div class="content">
		<div class="menu">
			<ul id="menu">
				@vertical_menu;noquote@
			</ul>
			<if @subsite_admin_p@>
			<h3>Admin</h3>
			<ul>
				<multiple name="applications">
						<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a>
						<if @applications.available@ not nil>
							 <a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">++</a>
						</if>
						</li>
				</multiple>
				<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
				<li><a href="@subsite_url@register/logout" title="#theme-mda.Logout#">Logout</a></li>
				<if @sw_admin_p@>
					<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
				</if>
			</ul>
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
		<div class="boxes">
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
		
			<slave>
		</div>

	</div>

	<div class="footer">
		<p> 2008 - Reunião 
Especializada sobre Agricultura Familiar (REAF) Mercosul - Permitida a 
cópia total ou parcial, desde que citada a fonte.<br>
          Secretaria da REAF - Unidade de Coordenação Regional Fida Mercosul (UCR Fida Mercosul) - COMITÉ TÉCNICO REAF<br>
          Edificio MERCOSUR - Luis Piera 1992 - Piso 2 - Oficina 201 - 
11.200 Montevideo, Uruguay - Telefax: (+598 2) 4136411 / 4136381
		</p>
	</div>

</div>
<script type="text/javascript">
    var menu=new menu.dd("menu");
    menu.init("menu","menuhover");
</script>

