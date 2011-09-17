<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_attr_types">      
      <querytext>

  select 
    attr.attribute_id, attr.attribute_name, attr.object_type,
    attr.pretty_name as attribute_name_pretty,
    datatype, types.pretty_name as pretty_name,
    nvl(description_key,'&nbsp;') as description_key, 
    description, widget
  from 
    acs_attributes attr, acs_attribute_descriptions d,
    cm_attribute_widgets w,
    ( select 
        object_type, pretty_name
      from 
        acs_object_types
      where 
        object_type ^= 'acs_object'
      connect by 
        prior supertype = object_type
      start with 
        object_type = :content_type
    ) types        
  where 
    attr.object_type = types.object_type
  and
    attr.attribute_id = w.attribute_id(+)
  and 
    attr.attribute_name = d.attribute_name(+)
  order by 
    types.object_type, sort_order, attr.attribute_name

      </querytext>
</fullquery>

</queryset>