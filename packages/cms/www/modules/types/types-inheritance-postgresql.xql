<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_content_type">      
      <querytext>

  select 
    case when ot2.supertype = 'acs_object' then '' else ot2.supertype end as parent_type,   
    case when ot2.object_type = 'content_revision' then '' else ot2.object_type end as object_type,
    ot2.pretty_name
  from 
    (select * from acs_object_types where object_type = :content_type) ot1,
    acs_object_types ot2
  where
    ot2.object_type != 'acs_object'
  and 
    ot1.tree_sortkey between ot2.tree_sortkey and tree_right(ot2.tree_sortkey)
  order by ot2.tree_sortkey asc

      </querytext>
</fullquery>

</queryset>