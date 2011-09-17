<?xml version="1.0"?>
<queryset>


<fullquery name="get_rel_types">      
      <querytext>
      
  select
    pretty_name, target_type, relation_tag, min_n, max_n
  from
    cr_type_relations r, acs_object_types o
  where
    o.object_type = r.target_type
  and
    r.content_type = :content_type
  order by
    pretty_name, relation_tag

      </querytext>
</fullquery>

 
<fullquery name="get_child_types">      
      <querytext>
      
  select
    pretty_name, child_type, relation_tag, min_n, max_n
  from
    cr_type_children c, acs_object_types o
  where
    c.child_type = o.object_type
  and
    c.parent_type = :content_type
  order by
    pretty_name, relation_tag

      </querytext>
</fullquery>

 
</queryset>
