<?xml version="1.0"?>
<queryset>

<fullquery name="get_data_info">      
  <querytext>      
	SELECT account_id, query_id, query_text, isactive, last_request
 	FROM mores_acc_query
 	where query_id = :query_id;
  </querytext>
</fullquery>

</queryset>
