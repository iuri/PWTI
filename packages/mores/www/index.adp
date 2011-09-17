<if @css@>
	<master src="/packages/openacs-default-theme/lib/mores-master">
</if>
<else> 
	<master>
	<link rel="stylesheet" type="text/css" href="mores.css2" /> 
	<link rel="stylesheet" type="text/css" href="styles.css2" />
</else>	
<style type="text/css">
	@extra_css;noquote@
</style>
	<multiple name=accounts>
	    <h2>@accounts.instance@</h2>
	    <div class="list-button-bar-top">
			<ul class="compact">
				<li><a class="button" title="Administrar contas" href="@accounts.instance_url@admin">Administrar contas  do @accounts.instance@ </a>
			</ul>
		</div>
	    

<table class="list-table" cellpadding="3" cellspacing="1" summary="Data for account_list">
    </thead>
	<tr class="list-header">
        <th class="list-table" id="account_list_name">
            Nome
        </th>
        <th class="list-table" id="account_list_description">
            Descrição
        </th>
        <th class="list-table" id="account_list_creation_date">
            Data de Ativação
        </th>
        <th class="list-table" id="account_list_qtd_mes">
            Qtd Mes / Qtd Total
        </th>
    </tr>
    </thead>
    <tbody>
    	<group column=instance>
	 	   <tr class="odd">
	 		   <td class="list-table" headers="account_list_name">
	 			    <a href="@accounts.instance_url@account?account_id=@accounts.account_id@">@accounts.account_name@</a>
		       </td>
		       <td class="list-table" headers="account_list_description">
					@accounts.description@
		       </td>
		       <td class="list-table" headers="account_list_creation_date">
					@accounts.creation_date@
		       </td>
		       <td class="list-table" headers="account_list_qtd_mes">
				 @accounts.qtd_mes@ / @accounts.qtd_total@
		       </td>
		  </tr>
     </group>   
      <tbody>
     </table>
	</multiple>

