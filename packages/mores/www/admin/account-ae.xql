<?xml version="1.0"?>
<queryset>

<fullquery name="get_data_info">      
  <querytext>      
	SELECT account_id, name, description, package_id, num_querys
 	FROM mores_accounts
 	where account_id = :account_id;
  </querytext>
</fullquery>

</queryset>
