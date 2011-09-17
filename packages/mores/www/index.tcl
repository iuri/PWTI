ad_page_contract {
    
    index file
    
    @author Breno Assunção (assuncao.b@gmail.com)
    @creation-date 2010-08-23
} {

}


	#template::head::add_css -href "/resources/mores/layouts/sebrae/css/css2.css"
	set css ""
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""

set page_add [parameter::get -parameter "page-add"]

set qtd_accounts  [db_string select_accounts { SELECT count(*)
			  FROM mores_accounts
				where package_id = :package_id;
	   } -default "0"]

set initial_configuration "no"
	   

	set initial_configuration "ok"
	
	template::multirow create accounts instance instance_url account_id account_name description creation_date qtd_mes qtd_total
	
	db_foreach select_account {		    
SELECT a.package_id as pkg_id, ap.instance_name as instance, a.account_id ,a.name,a.description,num_querys
		,to_char(o.creation_date, 'DD-MM-YYYY') as creation_date
		,st.mes, st.qtd_mes , sum(s.qtd) as qtd_total
	FROM  acs_objects o, mores_stat_source_query s,apm_packages ap, mores_accounts a

	left join (select a.account_id, to_char(s2.date,'MM/YYYY') as mes, sum(s2.qtd) as qtd_mes
		from mores_stat_graph s2, mores_accounts a
		where a.account_id = s2.account_id and to_char(s2.date,'MM/YYYY') = to_char(now(),'MM/YYYY') and tipo = 'dia'
		group by a.account_id, mes) st on a.account_id = st.account_id	

	where a.account_id = o.object_id and s.account_id = a.account_id AND a.package_id = ap.package_id 
	-- AND a.package_id = :package_id
	    and 't' = acs_permission__permission_p(a.account_id, :user_id, 'write')
	group by a.account_id,a.name,a.description,a.package_id,ap.instance_name, num_querys,o.creation_date, mes,qtd_mes
	order by instance_name, a.name, mes    
	} {
		set admin_p $admin_p	
		set instance_url [apm_package_url_from_id $pkg_id]
		template::multirow append accounts $instance $instance_url $account_id $name $description $creation_date $qtd_mes $qtd_total
			
	}
	
	set list_of_packages [db_list select_packages {SELECT distinct a.package_id as pkg_id	FROM mores_accounts a
		where  't' = acs_permission__permission_p(a.account_id, :user_id, 'write')}]
	
	set extra_css ""
	if {[llength $list_of_packages] == 1} {
		set extra_css [parameter::get -parameter "aditional_css" -package_id [lindex $list_of_packages 0]]
	}


