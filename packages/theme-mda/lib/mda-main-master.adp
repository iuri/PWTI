<master src="/www/blank-compat">
  <property name="title">@title@</property>
  <property name="header_stuff">
	<meta name="google-site-verification" content="5ZheQD-JALnc0wPVSaFf3NG9hG3JNyjKznoro_fb-Rk" />
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





<div id="site">
		
	
    <object style="height: 36px; border: 0pt none; overflow: hidden; width: 990px;" type="application/xhtml+xml" data="/barragoverno/barra.html" title="Barra Governo">
	<noscript><p>Barra do Governo</p></noscript>
        <!--[if IE]>
        <iframe src="/barragoverno/barra.html" style="width:990px; height:36px;" allowtransparency="true" frameborder="0" scrolling="no"></iframe>
         <![endif]-->
    </object>

	<div id="barra_mda">
		<ul> 
			<li class="image"><img src="/resources/theme-mda/imagens/mdamain/pg_inicial.gif" alt="Pagina Inicial"  /></li>
			<li class="name"><a href="@subsite_url@" title="Página Inicial">PÁGINA INICIAL</a></li>
	
				<li> 
					<ul class="redes"> 
						<li>REDES SOCIAIS</li>
						<li class="image"><img src="/resources/theme-mda/imagens/mdamain/twitter.gif" alt="Twitter" /></li>
						<li class="name"><a target="_blank" href="http://www.twitter.com/mdagovbr" title="Twitter">TWITTER</a></li>
						<li class="image"><img src="/resources/theme-mda/imagens/mdamain/youtube.gif" alt="Youtube"/></li>
						<li class="name"><a target="_blank" href="http://www.youtube.com/comunicacaosocialmda" title="Youtube">YOUTUBE</a></li>
						<li class="image"><img src="/resources/theme-mda/imagens/mdamain/flickr.gif" alt="Flickr"/></li>
						<li class="name"><a target="_blank" href="http://www.flickr.com/photos/desenvolvimentoagrario/" title="Flickr">FLICKR</a></li>
						<li class="image"><img src="/resources/theme-mda/imagens/mdamain/facebook.gif" alt="Flickr"/></li>
						<li class="name"><a target="_blank" href="http://pt-br.facebook.com/profile.php?id=100000889800731" title="FACEBOOK" alt="FACEBOOK">FACEBOOK</a></li>
					 </ul>
				</li>
			 <li class="image"><img src="/resources/theme-mda/imagens/mdamain/fale-conosco.gif" alt="Fale Conosco"/></li>
			 <li class="name"><a href="@subsite_url@/institucional/faleconosco" title="Fale Conosco"> FALE CONOSCO</a></li>
			
			 <li class="image"><img src="/resources/theme-mda/imagens/mdamain/intranet.gif" alt="Intranet"/></li>
			 <li class="name"><a href="http://www.mda.gov.br/intranet" title="Intranet"> INTRANET</a></li>
			 <li class="image"><img src="/resources/theme-mda/imagens/mdamain/webmail.gif" alt="Webmail"/></li>
			 <li class="name"><a href="https://mail.mda.gov.br/mdawebmail/src/login.php" title="Webmail"> WEBMAIL</a></li>
			
			 <li class="image"><img src="/resources/theme-mda/imagens/mdamain/rss.gif" alt="RSS"/></li>
			 <li class="name"><a href="@subsite_url@noticias/rss/" title="RSS"> RSS</a></li>
		 </ul>
	</div>

		<div id="topo">

			<div class="logo"><a href="@subsite_url@" title="logo"><img src="/resources/theme-mda/imagens/mdamain/logomin_gr.gif" alt="logo"/></a></div>


			<div id="ferramentas">
		   	       <div style="clear:both;"></div>
				<div class="search">
				   <form style="float: right; margin-right: 70px; margin-top: 10px;" id="cse-search-box" action="/portal/institucional/busca">
						<p>
						<label for="q">Busca:</label>
						<input name="cx" value="006027766869131785344:ythqh-jrkhc" type="hidden" /> 
						<input name="cof" value="FORID:10" type="hidden" />
						<input name="ie" value="UTF-8" type="hidden" /> 
						<input id="q" class="txtfield" name="q" size="31" type="text" value="Busca" onfocus="javascript:this.value='';return false" />
						<input name="sa" value="Buscar" type="submit" class="bt_search"/>
						</p>
				   </form> 
				   
			        </div> 
			</div>

	
	
	
	
		<!-- destaques MDA > controladores -->

	
		<include src="/packages/banners/lib/banners-programs" package_id="@programs_package_id@">

     </div>

      <div id="conteudo">



      <!-- menu esquerdo -->

  <div id="navesqu">

      <ul class="sf-menu sf-vertical" style="border-bottom:1px solid #ccc;">
		@vertical_menu;noquote@
      </ul>



      <div id="banners">

	 <include src="/packages/theme-mda/lib/layouts/mda6-2"
	            element_list="@element_list@"
	            element_src="@element_src@"
	            theme_id=@portal.theme_id@
	            portal_id=@portal.portal_id@
	            edit_p="f"
	    	    hide_links_p="f"
	            page_id=@page_id@
	            layout_id=@portal.layout_id@>

	  </div>

      </div>



	<script type="text/javascript">

	

		jQuery(function(){

			jQuery('ul.sf-menu').superfish();

		});

	</script>	
	
	<div id="boxes">
		<if @portal_page_p@ eq 0>
		<div class="breadcrumbs">	
			<if @context_title:rowcount@ not nil>
				<multiple name="context_title">
						<a class="breada" href="@context_title.url@" title="@context_title.label@">@context_title.label;noquote@</a> >
				</multiple>
				<strong class="bread">@title;noquote@</strong>
					<if @subsite_admin_p@><a href="@subsite_url@/admin/menus/choose-parent">Tornar esta página um item de menu</a></if>
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
	<div id="footer">
		<div class="banners_box">
			<include src="/packages/banners/templates/banners-tworow" package_id="@banners_package_id@">
		</div>

		<div id="box-right">
			<ul id="banner-fixo">
				<li><a onclick="window.open(this.href); return false" href="/portal/institucional/Prestação_de_Contas_Anuais"><img src="/resources/theme-mda/imagens/mdamain/processos-de-contas.gif" alt="Processo de Contas"/> </a></li>
				<li><a onclick="window.open(this.href); return false" href="http://www.mda.gov.br/transparencia/"><img src="/resources/theme-mda/imagens/mdamain/transparencia-publico.gif" alt="Transparencia Pública"/> </a></li>
				<li><a onclick="window.open(this.href); return false" href="http://www.secom.gov.br/sobre-a-secom/publicacoes/caderno-destaques"><img src="/resources/theme-mda/imagens/mdamain/caderno-destaques.gif" alt="Cardeno Destaque"/> </a></li>
				<li><a onclick="window.open(this.href); return false" href="/portal/arquivos/download/Relatorio_de_gestao.pdf?file%5fid=3725541"><img src="/resources/theme-mda/imagens/mdamain/CGU.gif" alt="CGU"/></a> </li>
			</ul>
			<p class="site_name"><strong>Portal do Ministério do Desenvolvimento Agrário </strong></p>
				<address>Esplanada dos Ministérios, Bloco A/Ala Norte - 
			CEP 70050-902 - Brasília-DF</address>

		</div>

		



</div>
<div id="base">


	<p> <span style="float: left; margin-top: 7px;"><img alt="Login Portal" src="/resources/theme-mda/imagens/mdamain/login.gif" style="margin-right: 5px;"/></span>
		<span style="margin-top: 10px; float: left;">
		
		<if @untrusted_user_id@ eq 0>
				<a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Àrea Restrita</a>
		</if>
		<else>
				<a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a>
		</else>
		</span>
	</p>
	<p> 
		<a rel="license" href="http://creativecommons.org/licenses/by-nc/2.5/br/"><img alt="Licença Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-nc/2.5/br/88x31.png"/></a><br />O Está obra está licenciada sob uma <a rel="license" href="http://creativecommons.org/licenses/by-nc/2.5/br/">Licença Creative Commons</a>.
	</p>

	<p> <img alt="OpenACS" src="/resources/theme-mda/imagens/mdamain/open-ACS.gif"/> <br/>Portal Desenvolvido em <a href="http://www.openacs.org" title="Portal Desenvolvido em OpenACS">OpenACS</a> </p>

	<p>
		<a href="http://validator.w3.org/check?uri=referer"><img width="88" height="31" alt="Valid XHTML 1.0 Strict" src="http://www.w3.org/Icons/valid-xhtml10"/></a>
<img alt="Acessibilidade" src="http://www.acessobrasil.org.br/dasilva/imgs/selo_acessobr92x47.gif"/> <br/>
	</p>
</div>

<div>
	<if @subsite_admin_p@>
		<ul>
			<multiple name="applications">
				<li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a>
					<if @applications.available@ not nil>
						 <span><a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&amp;application_key=@applications.package_key@&amp;return_url=@return_url@">Add portlet Application</a></span>
					</if>
				</li>
			</multiple>
			<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
			<if @sw_admin_p@>
				<li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&amp;referer=@return_url@">Portal Edit</a></li>
			</if>
		</ul>
    </if>	
</div>


</div><!-- fecha tudo -->

<script type="text/javascript" src="http://www.google-analytics.com/urchin.js"></script>
<script type="text/javascript">
<!--
	_uacct = "UA-2291113-2";
	urchinTracker();
-->

</script>
<noscript><p>Javascript Habilite esse recurso para website</p></noscript>
