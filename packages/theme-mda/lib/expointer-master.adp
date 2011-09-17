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
	<iframe width="1000" height="36" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/barragoverno/barra.html"></iframe>


	<div class="header"><img src="/resources/theme-mda/imagens/expointer/topo.jpg" align="center"/> </div>

 <div id="menu">
    <ul>
	  <li><a href="@subsite_url@" title="Home">Home</a></li>
      <li><a href="@subsite_url@/noticias">Notícias</a></li>
      <li><a href="@subsite_url@/radio">Rádio MDA</a></li>
      <li><a href="@subsite_url@/videos">Vídeos</a></li>
	  <li><a href="@subsite_url@/fotos">Fotos</a></li>
	  <li><a href="@subsite_url@/paginas/Expointer">Expointer</a></li>
      <li><a href="@subsite_url@/saladeimpresa">Imprensa</a></li>
	  <li><a href="@subsite_url@/paginas/Participe">Participe</a></li>
		<if @untrusted_user_id@ eq 0>
			<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
		</if>
		<else>
			<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
		</else>
	</ul>
  </div>
  <!--
 <div id="menuadmin">
    <ul>
	

	
	<if @subsite_admin_p@>
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
	</if>
    </ul>
  </div>
-->
	<div class="content">

		<if @portal_page_p@ not eq 1>
			<div class="content_text">
			<!-- <h2>@title@</h2> -->
		</if>

		<slave>

		<if @portal_page_p@ not eq 1>
			</div>
		</if>

	</div>

	<div  id="rodape" align="center"> <br />

    	<br />
	    <a href="http://www.youtube.com/user/mdaexpointer"><img src="/resources/theme-mda/imagens/expointer/youtube.gif" alt="youtube-mda-expointer" border="0" align="baseline" /></a> <a href="http://www.orkut.com.br/Main#Profile.aspx?rl=mp&amp;uid=18063837913384356977"><img src="/resources/theme-mda/imagens/expointer/orkut.gif" alt="orkut-mda-expointer" border="0" /></a> <a href="http://twitter.com/mdaexpointer"><img src="/resources/theme-mda/imagens/expointer/twitter.gif" alt="twitter - mda - expointer" border="0"/></a> <a href="http://www.flickr.com/photos/41927571@N04/"><img src="/resources/theme-mda/imagens/expointer/flickr.gif" alt="flickr -mda-expointer" border="0"/></a>
    	<p>Portal do Ministério do Desenvolvimento Agrário <br />

	      Esplanada dos Ministérios, Bloco A / Ala Norte - CEP 70054-900 - Brasília - DF</p>

	</div>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-10453452-1");
pageTracker._trackPageview();
} catch(err) {}</script>


</div>




