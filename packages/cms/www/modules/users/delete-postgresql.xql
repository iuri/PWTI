<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_group">      
      <querytext>

        select acs_group__delete(:id)
      </querytext>
</fullquery>

 
<fullquery name="get_status">      
      <querytext>
      
  select coalesce((select 'f'  where exists (
            select 1 from acs_rels 
              where object_id_one = :id 
              and rel_type in ('composition_rel', 'membership_rel'))),
          't') as is_empty 
      </querytext>
</fullquery>

 
</queryset>
