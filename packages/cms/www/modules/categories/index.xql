<?xml version="1.0"?>
<queryset>

<fullquery name="get_parent_info">      
      <querytext>
      
   select o.context_id as parent_id, k.heading as parent_heading
     from  acs_objects o, cr_keywords k
    where object_id = :id
      and o.object_id = k.keyword_id

      </querytext>
</fullquery>

 
</queryset>
