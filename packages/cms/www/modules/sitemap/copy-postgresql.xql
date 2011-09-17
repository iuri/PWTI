<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="copy_item">      
      <querytext>

        select content_item__copy(
                :cp_item_id,
                :folder_id,
	        null,
	        null
            ); 
           
      </querytext>
</fullquery>

 
<fullquery name="get_path">      
      <querytext>
      
  select
    content_item__get_path( :folder_id, null )
  from 
    dual

      </querytext>
</fullquery>

 
<fullquery name="get_marked">      
      <querytext>
      
  select
    content_item__get_title(item_id, 'f') as title, 
    content_item__get_path(item_id,:root_id) as name, 
    item_id, parent_id
  from
    cr_items
  where
    item_id in ([join $clip_items ","])
  and
    -- only for those items which user has read
    acs_permission__permission_p(item_id, :user_id, 'read') = 't'

      </querytext>
</fullquery>

 
</queryset>
