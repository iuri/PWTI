<?xml version="1.0"?>
<queryset>

<fullquery name="get_info">      
      <querytext>
      
  select 
    i.content_type, i.latest_revision, r.description
  from 
    cr_items i, cr_revisions r
  where 
   i.item_id = :item_id
  and 
   r.revision_id = content_item__get_best_revision(:item_id)

      </querytext>
</fullquery>

<fullquery name="get_item_title">
 <querytext>

  select title from cr_revisions where revision_id = :latest_revision

 </querytext>
</fullquery>
 
</queryset>
