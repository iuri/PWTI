<master src="/www/blank-compat">
  <property name="title">@title@</property>
  <property name="header_stuff">
    @header_stuff;noquote@
	<style type="text/css">
		body {
			background: @background_color@ url("/resources/theme-mda/imagens/feira2009/fundo0@random_top@.jpg") no-repeat top;
		}
	</style>

	<script type='text/javascript'>
        var $j = jQuery.noConflict();
    </script>

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
	<div class="barra_ministerio">
	<iframe width="1008" height="36" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/barragoverno/barra.html"></iframe>
	</div>

	<if @portal_page_p@ not eq 1>
			<div class="topo-interno">
	</if>
	<else>
		<div class="topo">
	</else>
		
		<div class="top-left">
			<div class="logo"><a href="@subsite_url@"><img src="/resources/theme-mda/imagens/feira2009/logo.png"/></a></div>


		 
			<if @portal_page_p@ eq 1>

			<div id="videos_div"><include src="/packages/videos/templates/portal-playlist-portlet" package_id="@videos_package_id@"></div>
	
			</if>
		</div>

		<div class="top-right">


		<ul id="menu-superior">
			@superior_menu;noquote@

		<!-- <li><form action="" method="get" id="busca">
			<label>
				<input name="busca" type="text" value="Buscar" />
			</label>
		</form></li> -->
		</ul>
		
		<div class="info"><a href="/feira2009/paginas/ingressos"><img width="401" height="159" src="/resources/theme-mda/imagens/feira2009/info.png"></a></div>
		<if @portal_page_p@ eq 1>
		<div class="destaques" id="destaques">
                <div class="destaque-prev"><p><a id="prev" href="#" onclick="javascript:moveVideo('prev'); return false"><img src="/resources/theme-mda/imagens/feira2009/seta-left.png"/></a></p></a></div>
				<div class="destaque-next"><p><a id="next" href="#" onclick="javascript:moveVideo('next');; return false"><img src="/resources/theme-mda/imagens/feira2009/seta-right.png"/></a></p></div>
					<multiple name="child_photo">
						<div class="destaque-box" <if @child_photo.rownum@ not eq 1>style="display:none;"</if><else>style="display:inline"</else> name="dest" id="destaque@child_photo.rownum@">
							<div class="destaque-foto"> <img width="350" height="231" src="@destaques_url@images/@child_photo.thumb_path@"/> </div>
							<div class="destaque-titulo"> <if @child_photo.link@ not nil> <a href="@child_photo.link@"></if> @child_photo.caption@ <if @child_photo.link@ not nil> </a> </if></div>
							<div class="destaque-noticia"> @child_photo.story@ </div>
						</div>
					</multiple>
		</div>
		</if>
		
		</div>
	</div>

	<div class="imagem-rio"><div id="rio"><img src="/resources/theme-mda/imagens/feira2009/top01.png"/></div>
		<ul id="menu-inferior">
			@inferior_menu;noquote@
			<if @untrusted_user_id@ eq 0>
				<li><a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Entrar</a></li>
			</if>
			<else>
				<li><a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a></li>
			</else>
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
	
	</div>

	<div id="conteudo">
		
		<slave>
	</div>
	
	
	<div id="rodape">
	</div>


	
	<div id="creativecommons"><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.5/br/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/2.5/br/88x31.png" /></a><br />Esta obra est&#225; licenciada sob uma <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/2.5/br/">Licen&#231;a Creative Commons</a>.</div>


	</div>

</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-10778812-1");
pageTracker._trackPageview();
} catch(err) {}</script>

<script type="text/javascript" src="/resources/ajaxhelper/twitter/blogger.js"></script>
<script type="text/javascript" src="http://twitter.com/statuses/user_timeline/feiramda.json?callback=twitterCallback2&count=3"></script>

<script type="text/javascript">
function mostrarGrafico(div){
    //esconde todas

	var videos = getElementsByName_bugIE("div","dest");
	
	var i = 0;
	for(i=0; i < videos.length; i++){
	   videos[i].style.display ="none";
	}
	     // mostra uma 

	document.getElementById(div).style.display = "inline";
	
}

function moveVideo(direction){
	var current = 0;
	var videos = getElementsByName_bugIE("div","dest");
	
	var i = 0;
	for(i=0; i < videos.length; i ++){
	  if(videos[i].style.display == "inline"){
		current = i;	
	  }
	}
	if(direction == "next"){
		if((current + 1) < videos.length){
			current +=2;
		} else{
			current = 1;
		}
	}else{
		if(current == 0){
			current = videos.length;
		} else{
			// não precisa fazer nada para diminuir pois o indice de videos começa em 1
		}
	}
	
	var newVideo = "destaque" + current;

	mostrarGrafico(newVideo);
	
}

function getElementsByName_bugIE(tag,name){  
     

   var elementos = document.getElementsByTagName(tag);  
   var result = new Array();  
     for(i = 0,i2 = 0; i < elementos.length; i++) {  
        att = elementos[i].getAttribute("name");  
        if(att == name) {  
            result[i2] = elementos[i];  
            i2++;  
        }  
     }  
     return result;  
}

function destaque(){ 
	var i = 0; 
	i = setInterval("moveVideo('next')",5000);
}


  
</script>
