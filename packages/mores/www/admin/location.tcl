ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""

if {$admin_p eq 1} {
	set action_list {"#action-manager.New-location#" location-new "#action-manager.New-location#"}
}
set context [list [list "." Matrizes] Locais]


template::list::create -name location_list -multirow location_list -key territory_location_id -actions $action_list -pass_properties {
} -elements {
    name {
        label "Localização"
        display_template {
	        @location_list.name@
	    }
    }
    ibge_code {
        label "Código IBGE"
        display_template {
	        @location_list.ibge_code@
	    }
    }
    sdt_code {
        label "Código SDT"
        display_template {
	        @location_list.sdt_code@
	    }
    }
    uf_code {
        label "UF"
        display_template {
	        @location_list.uf_code@
	    }
    }
	actions {
        label "Ações"
        display_template {

	        <a class="button" href="location-del?territory_location_id=@location_list.territory_location_id@">
				#action-manager.Delete_location#
			</a> 
	        <a class="button" href="location-new?territory_location_id=@location_list.territory_location_id@">
				#action-manager.Edit_data#
			</a>


        }
    }
}

db_multirow  location_list  select_locations {
   SELECT territory_location_id
   		,name
   		,package_id
   		,ibge_code
   		,sdt_code
   		,uf_code
  FROM am_territory_location
	where   package_id = :package_id	
        and 't' = acs_permission__permission_p(territory_location_id, :user_id, 'read')
} {
set admin_p $admin_p
}
