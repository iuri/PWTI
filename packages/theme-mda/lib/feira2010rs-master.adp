<master src="/www/blank-compat">
  <property name="title">@title@</property>
  <property name="header_stuff">
    @header_stuff;noquote@


	<script type="text/javascript">

	$(document).ready(function(){

		$("h2.trigger").toggle(function(){
			$(this).addClass("active"); 
		}, function () {
			$(this).removeClass("active");
		});
		$("h2.trigger").click(function(){
			$(".toggle_container").slideUp('slow');
			$(this).next(".toggle_container").slideToggle("slow,");
		});
		$("#link").click(function() {
			window.location = '@subsite_url@';	
		});
	});

	</script>

   </property>
   <if @portal_page_p@ not eq 1>
	<style type="text/css">
		#topo {
			background:url(/resources/theme-mda/imagens/feira2010rs/topo-interno-0@random_top@.gif) no-repeat;
			//background:url(/resources/theme-mda/imagens/feira2010rs/topo-interno-02.gif) no-repeat;
			height:312px;
		}
	</style>
   </if>
   <else>
	<style type="text/css">
		#topo {
			background:url(/resources/theme-mda/imagens/feira2010rs/topo-0@random_top@.gif) no-repeat;
		}
	</style>
    </else>

 
  <if @context@ not nil><property name="context">@context;noquote@</property></if>
    <else><if @context_bar@ not nil><property name="context_bar">@context_bar;noquote@</property></if></else>
  <if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
  <if @doc_type@ not nil><property name="doc_type">@doc_type;noquote@</property></if>
     <if @untrusted_user_id@ ne 0>
    </if>
    <else>
    </else>

<div id="wrap">
	<iframe width="1008" height="36" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/barragoverno/barra.html"></iframe>
	
	 <div id="topo"> 
		<div style="width:450px; height:550px;float:left;">
                	<div id="link" style="width: 450px; height: 450px;float:left;cursor:pointer;"></div>
		</div>
		<div style="width:490px; height:500px;float:right;">
		
		<div id="menu-superior">
			<ul>
				@superior_menu;noquote@
			        <!-- <li class="dot">&nbsp;</li> -->
		        </ul>
    		</div>
		 <if @portal_page_p@ eq 1>

		<div class="container">

		<h2 class="trigger"><a href="#">Programação</a></h2>
		<div class="toggle_container">
			<div>
				<multiple name="child_photo">
					<div id="destaque-story"> 
					@child_photo.story;noquote@
					<p><a href="/feirars/paginas/Programação_Cultural">Acesse a programação completa</a></p>
					</div>
					<!-- @child_photo.story;noquote@ -->
					
					<div id="destaque-foto"><if @child_photo.link@ not nil> <a href="@child_photo.link@"></if> <img src="@destaques_url@images/@child_photo.thumb_path@"/> <if @child_photo.link@ not nil> </a> </if></div>
			</multiple>
	

			</div>
	
		  </div>

		  <h2 class="trigger"><a href="#">Como Chegar</a></h2>
		     	<div class="toggle_container" style="display:none;">
				<div>
					<h3>Cais do Porto - Porto Alegre - RS</h3>
					<div style="margin-left:15px;"><a href="/feirars/paginas/maps"><img src="/resources/theme-mda/imagens/feira2010rs/maps.jpg"></a></div>
				</div>
			</div>

	
			<h2 class="trigger"><a href="#">Horário/Data/Ingressos</a></h2>
			<div class="toggle_container" style="display:none;">
			<div>
					<h3>Feira</h3>
					Quinta e sexta-feiras (13 e 14/5): das 11h às 21h<br>
					Sábado (15/5) e domingo (16/5): das 10h às 22h<br>
					Entrada franca para a Feira todos os dias<br>
					<h3>Shows</h3>
					Quinta a sábado: das 19h às 22h<br>
					Domingo: a partir das 16h<br>
					Classificação etária: livre (acompanhados dos pais)<br>
					Ingressos: R$ 10,00 (inteira) e R$ 5,00 (meia), à venda no local<p><br>
					</p>

			</div>
		</div>
		</div>
   		</if>
			
	</div>
   
</div>
		 

<if @portal_page_p@ eq 1>
<div id="redesocial">
	<ul id="box-redesocial"> 
		<li><a target="_blank" href="http://www.twitter.com/feiramda" title="Twitter do Brasil Rural Contemporâneo"><img src="/resources/theme-mda/imagens/feira2010rs/twitter.gif" alt="Twitter do Brasil Rural Contemporâneo" border="0" align="left"/></a></li>
		<li id="upbox"></li>
		<li><a target="_blank" href="http://www.flickr.com/photos/feiramda" title="Flickr Brasil Rural Contemporâneo"><img src="/resources/theme-mda/imagens/feira2010rs/flickr.gif" alt="Flickr Brasil Rural Contemporâneo" border="0" align="right"/></a></li>
		<li><a target="_blank" href="http://www.youtube.com/comunicacaosocialmda" title="Youtube MDA"><img src="/resources/theme-mda/imagens/feira2010rs/youtube.gif" alt="Youtube MDA" border="0" align="right"/></a></li>
		<li><a target="_blank" href="http://pt-br.facebook.com/profile.php?id=100000889800731" title="Facebook MDA"><img src="/resources/theme-mda/imagens/feira2010rs/facebook.gif" alt="Facebook MDA" border="0" align="right"/></a></li>
		<li><a target="_blank" href="/feirars/noticias/rss/" title="RSS Brasil Rural Contemporâneo"><img src="/resources/theme-mda/imagens/feira2010rs/rss.gif" alt="RSS Brasil Rural Contemporâneo" border="0" align="right"/></a></li>
	</ul>

</div>
</if>

<div id="conteudo">
	<if @portal_page_p@ not eq 1>
			<p class="page_title">@title@</p>
	</if>


	<slave>
</div>
<ul id="footer"> 
<li></li>
</ul>





<if @subsite_admin_p@>
		<ul id="menu-inferior-admin">
				<if @sw_admin_p@>
					<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
				</if>
				<if @subsite_admin_p@>
					<multiple name="applications">
						<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a></li>
							<if @applications.available@ not nil>
								<li><a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">Add</a></li>
							</if>
					</multiple>
					<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
				</if>
				<if @subsite_admin_p@><li><a href="@subsite_url@/admin/menus/choose-parent">Tornar esta página um item de menu</a></a></if>
		</ul>
</if>
<ul style="text-align:center;">
<if @untrusted_user_id@ eq 0>
	<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
</if>
<else>
	<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
</else>
</ul>

<div id="creativecommons"><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.5/br/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.5/br/88x31.png" /></a><br />Esta obra est&#225; licenciada sob uma <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.5/br/">Licen&#231;a Creative Commons</a>.</div>

</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-16238287-1");
pageTracker._trackPageview();
} catch(err) {}</script>
