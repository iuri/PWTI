<?xml version="1.0"?>

<queryset>

<fullquery name="get_related_types">      
      <querytext>
select
    pretty_name, target_type, relation_tag, min_n, max_n
  from
    cr_type_relations r, acs_object_types o
  where
    o.object_type = r.target_type
  and
    r.content_type = content_item__get_content_type(:item_id)
  order by
    pretty_name, relation_tag;
      </querytext>
</fullquery>


</queryset>
