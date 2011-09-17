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




<div id="wrap">
	<!-- Inicio Barra Ministerio -->
	<iframe width="1008" height="36" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/barragoverno/barra.html"></iframe>
	<!-- Fim  Barra Ministerio -->

  	<!-- Inicio Topo -->

  	<div id="header">
    		<div id="menu-superior">
      			<ul>
				@topo_menu;noquote@

				<if @untrusted_user_id@ eq 0>
					<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
				</if>
				<else>
					<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
				</else>
      			</ul>
    		</div>

		<if @sw_admin_p@>
			<div id="menu-admin">
				<ul>
					<if @sw_admin_p@>
							<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
					</if>

					<if @subsite_admin_p@>
						<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
				   		<multiple name="applications">
								<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a>
									<if @applications.available@ not nil>
										 <a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">++</a>
									</if>
								</li>
						</multiple>
						<li><a href="@subsite_url@/admin/menus/choose-parent">Tornar esta página um item de menu</a></li>
					</if>
				</ul>
			</div>
		</if>
		
    		<div class="logo_territorios"><a href="@subsite_url@"><img src="/resources/theme-mda/imagens/salaoterritorios/ft0@random_top@.jpg"/></a></div>
		<div class="curvas"><img src="/resources/theme-mda/imagens/salaoterritorios/curvas.gif"/> </div>
  	</div>

  	<!-- Fim  Topo-->

    	<!-- Inicio Menu Secundario-->
    	<div id="menu_secundario">
	      <ul>
		@secundario_menu;noquote@
      	     </ul>
    	</div>
    	<!-- Fim Menu Secundario-->
    		

  	<!-- Inicio Conteúdo -->

 	<div id="content">

		<!-- user messages -->
		<if @user_messages:rowcount@ gt 0>
		   <div id="alert-message">
		      <ul>
		        <multiple name="user_messages">
		            <div class="alert"><strong>@user_messages.message;noquote@</strong></div>
		        </multiple>
		      </ul>
		   </div>
		 </if>
		<!-- fim user messages -->

		<!-- início do conteúdo -->
		<slave>
		<!-- fim do conteúdo -->
       </div> 
       <div id="footer">

       </div>
</div>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-12771733-1");
pageTracker._trackPageview();
} catch(err) {}</script>
