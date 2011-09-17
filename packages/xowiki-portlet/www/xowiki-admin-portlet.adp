
<!-- <#Manage_Pages_of Manage Pages of#> <a href='@applet_url@'><#XoWiki XoWiki#></a> -->
<if @applet_url@ not eq "/">
<h1><a href="@applet_url@">Espaço Colaborativo</a></h1>
<ul>
 
<div class="block_admin_comunidades">
	<div class="titulo_espaco_colaborativo"><h3>Páginas membros</h3></div>
	<div class="titulo_espaco_colaborativo02"><h3>Páginas não-membros</h3></div>
	<div class="espaco_colaborativo_paginas">
		<ul>
			<multiple name="content">
			  <li>
			    @content.pretty_name@<small> <a class="button" href="@applet_url@admin/portal-element-remove?element_id=@content.element_id@&referer=@referer@&portal_id=@template_portal_id@">#acs-subsite.Delete#</a></small>
			  </li>
			</multiple>
		</ul>
	</div>
	<div class="espaco_colaborativo_paginas_naomembro">
		<ul>
		<multiple name="non_content">
		  <li>
		    @non_content.pretty_name@<small> <a class="button" href="@applet_url@admin/portal-element-remove?element_id=@non_content.element_id@&referer=@referer@&portal_id=@template_non_portal_id@">#acs-subsite.Delete#</a></small>
		  </li>
		</multiple>
		</ul>
	</div>
</div>


	<if @package_id@ eq "">
	  <small><#lt_No_community_specifie No community specified#></small>
	</if>
	<else>
	<ul>
	@form;noquote@
	</ul>
	</else>
</if>

