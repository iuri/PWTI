<?xml version="1.0"?>
<queryset>

<fullquery name="get_subtypes">      
      <querytext>
      
  select object_type, pretty_name 
    from acs_object_types
   where supertype = :content_type
   order by object_type asc

      </querytext>
</fullquery>

</queryset>