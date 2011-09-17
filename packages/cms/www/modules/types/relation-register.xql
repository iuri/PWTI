<?xml version="1.0"?>
<queryset>

<fullquery name="get_pretty_name">      
      <querytext>
      
  select
    pretty_name
  from
    acs_object_types
  where
    object_type = :content_type

      </querytext>
</fullquery>

 
</queryset>
