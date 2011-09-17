<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_attr_types">      
      <querytext>

  select 
    attr.attribute_id, attr.attribute_name, attr.object_type,
    attr.pretty_name as attribute_name_pretty,
    datatype, types.pretty_name as pretty_name,
    coalesce(description_key,'&nbsp;') as description_key, 
    description, widget
  from 
    acs_attributes attr left outer join cm_attribute_widgets w using (attribute_id)
    left outer join acs_attribute_descriptions d using (attribute_name),
    ( select 
        o2.object_type, o2.pretty_name
      from 
        (select * from acs_object_types where object_type = :content_type)  o1,
        acs_object_types o2
      where 
        o2.object_type != 'acs_object'
      and 
        o1.tree_sortkey between o2.tree_sortkey and tree_right(o2.tree_sortkey)
    ) types        
  where 
    attr.object_type = types.object_type
  order by 
    types.object_type, sort_order, attr.attribute_name

      </querytext>
</fullquery>

</queryset>