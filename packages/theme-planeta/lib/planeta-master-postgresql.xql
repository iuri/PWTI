<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_portal">
        <querytext>
	select portals.name,
	           portals.portal_id,
	           portals.theme_id,
                   portal_layouts.layout_id,
                   portal_layouts.filename as layout_filename,
                   portal_layouts.resource_dir as layout_resource_dir,
                   portal_pages.page_id
            from portals,
                 portal_pages,
                 portal_layouts
            where portal_pages.sort_key = 0
            and portal_pages.portal_id = :portal_id
            and portal_pages.portal_id = portals.portal_id
            and portal_pages.layout_id = portal_layouts.layout_id
        </querytext>
    </fullquery>

    <fullquery name="select_element">
        <querytext>

	  SELECT portal_element_map.element_id,
	  portal_element_map.region,
          portal_element_map.sort_key
	  FROM portal_element_map, portal_pages
          WHERE portal_pages.portal_id = :portal_id
          AND portal_element_map.page_id = :page_id
          AND portal_element_map.page_id = portal_pages.page_id
	  AND portal_element_map.state != 'hidden'
	  ORDER BY portal_element_map.region, portal_element_map.sort_key

        </querytext>
    </fullquery>


    
    <fullquery name="select_applications">
      <querytext>
	
	SELECT p.package_id,
	p.instance_name,
	n.node_id, 
	n.name,
	p.package_key
	FROM site_nodes n, apm_packages p, apm_package_types t
	WHERE n.parent_id = :subsite_node_id
	AND p.package_id = n.object_id
	AND t.package_key = p.package_key
	AND t.package_type = 'apm_application'
	AND exists (SELECT 1 
  	            FROM all_object_party_privilege_map perm 
		    WHERE perm.object_id = p.package_id
		    AND perm.privilege = 'read'
		    AND perm.party_id = :user_id)
	ORDER BY upper(instance_name)

      </querytext>
    </fullquery>

</queryset>
