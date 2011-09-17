<?xml version="1.0"?>
<queryset>

<fullquery name="get_attr_info">      
      <querytext>
      
  select
    attribute_name, object_type as content_type
  from
    acs_attributes
  where
    attribute_id = :attribute_id

      </querytext>
</fullquery>

 
</queryset>
