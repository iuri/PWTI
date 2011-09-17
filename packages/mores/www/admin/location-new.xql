<?xml version="1.0"?>
<queryset>

<fullquery name="get_data_info">      
  <querytext>      
	SELECT territory_location_id, name, package_id, ibge_code, sdt_code, uf_code
    FROM am_territory_location
	where territory_location_id = :territory_location_id;
  </querytext>
</fullquery>

</queryset>
