<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_content_type">      
      <querytext>

  select 
    decode (supertype, 'acs_object', '', supertype) as parent_type,   
    decode (object_type, 'content_revision', '', object_type) as object_type,
    pretty_name
  from 
    acs_object_types
  where
    object_type ^= 'acs_object'
  connect by 
    object_type = prior supertype
  start with 
    object_type = :content_type
  order by 
    rownum desc

      </querytext>
</fullquery>

</queryset>