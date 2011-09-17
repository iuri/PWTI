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

	<div id="header">
		<p style="float:right;">
			<img src="/resources/theme-mda/imagens/biofach/bandeira-brasil.gif"><span style=""><a href="/acs-lang/change-locale?user_locale=pt_BR&amp;return_url=@return_url@"> Português </a> </span><img src="/resources/theme-mda/imagens/biofach/inglaterra.gif">
			 <span style="margin-top:-10px;"><a href="/acs-lang/change-locale?user_locale=en_US&amp;return_url=@return_url@"> English </a></span>
		</p>
	</div>

 <div id="menu">
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


 	

	<div id="footer"> 
		<p><b><a href="http://www.mda.gov.br/portal/" title="Ministério do Desenvolvimento Agrário-MDA">Ministério do Desenvolvimento Agrário</a></b><br />
		Esplanada dos Ministérios, Bloco A/Ala Norte - CEP 70050-902 - Brasília-DF </p>
		</p>
	</div>
	
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
									 <a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">+</a>
								</if>
							</li>
					</multiple>
					<li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
					<li class="ativo"><a href="@subsite_url@/admin/menus/choose-parent">Tornar esta página um item de menu</a></a>
				</if>
		</if>
    </ul>
    </div>


<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-21316490-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

</div>




