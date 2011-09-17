<master src="/www/blank-compat">
  <property name="title">@title@</property>
  <property name="header_stuff"> @header_stuff;noquote@ </property>
  <if @context@ not nil><property name="context">@context;noquote@</property></if>
  <if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
  <if @doc_type@ not nil><property name="doc_type">@doc_type;noquote@</property></if>
   

<div id="main"> 

<!-- Navegação -->
<div id="menu">
<div id="links_home">
<a class="link menu" href="/page"><span>Página Inicial </span></a> | 
<a class="link" href="/planeta"><span>Meus Monitoramentos</span></a>
</div>
<ul class="menu">
<li> <a href="/page/contato" title="Planeta web - Contato">Contato</a> </li>
<li> <a href="/page/cases" title="Planeta web - Cases de sucesso">Cases </a></li>
<li> <a href="/page/clientes" title="Planeta web - Clientes">Clientes</a> </li>
<li> <a href="/page/funcionalidades" title="Planeta web - Funcionalidades">Funcionalidades</a> </li>
<li> <a href="/page/por_que_monitorar" title="Planeta web - Monitoramento">Por que Monitorar?</a> </li>
<li> <a href="/page/pwti" title="Planeta web - Contato">Quem Somos </a></li>
</ul> 
 
</div>
<!-- Fecha Navegação -->

<!-- Header -->
<div id="header"> 

<p class="logomarca">
	<if @system_url@ not nil>
		<a href="@system_url@" title="Pagina Inicial">
			<img src="/resources/theme-planeta/logomarca-planeta-web.gif" alt="Planeta web Tecnologias Interativas - Logomarca" border="0" />
		</a>
	</if>  <else>
			<a href="@subsite_url@" title="Pagina Inicial">
			<img src="/resources/theme-planeta/logomarca-planeta-web.gif" alt="Planeta web Tecnologias Interativas - Logomarca" border="0" />
		</a>

	</else>
</p>
	
	<p class="botao-entrar">
		<if @untrusted_user_id@ eq 0>
			<a href="/register?return_url=/planeta/" title="Entra - Login Planeta Web">
				<img src="/resources/theme-planeta/botao-entrar-login.gif" alt="Planeta Web Tecnologias Interativas - Botão" border="0" />
			</a>
		</if>
		<else>
			<a href="/register/logout" title="Sair do Portal">
				<img src="/resources/theme-planeta/botao-logout.gif" alt="Planeta Web Tecnologias Interativas - Botão" border="0" />
			</a>
		</else>
	</p>
	<div id="breadcrumbs">


		  <if @context_bar@ not nil>
		    @context_bar;noquote@
		  </if>
		  <else>
		    <if @context:rowcount@ not nil>
		    <ul class="compact">
		      <multiple name="context">
		      <if @context.url@ not nil>
		        <li><a href="@context.url@">@context.label@</a> @separator@</li>
		      </if>
		      <else>
		        <li>@context.label@</li>
		      </else>
		      </multiple>
		    </ul>
		    </if>
		  </else>

		</div>
</div>
<!-- Fecha Header -->

 
 <!-- Abre content  -->
  <slave>
 <!-- Fecha content -->

  <!-- Abre footer  -->

  <div id="footer"> <span> <a style="text-decoration: none; color: rgb(214, 71, 31);" href="http://pwti.com.br" >Planeta Web Tecnologias Interativas</a></span> 
	<img src="/resources/theme-planeta/facebook-planeta-web.gif" alt="Facebook Planeta Web" border="0" />
	<img src="/resources/theme-planeta/twitter-planeta-web.gif" alt="Facebook Planeta Web" border="0" />
	<img src="/resources/theme-planeta/email-planeta-web.gif" alt="Facebook Planeta Web" border="0" />
	
		</span>
	</p>



  </div>
<!-- Fecha fotter -->
</div>
<!-- Fecha main -->



