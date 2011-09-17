<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="select_open_contents">
      <querytext>
select bt_contents.content_number,
                bt_contents.summary,
                to_char(acs_objects.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date_pretty                
                from bt_contents, acs_objects, workflow_cases cas, workflow_case_fsm cfsm
                where bt_contents.content_id = acs_objects.object_id
                 and  $sql_where_clause
               order by acs_objects.creation_date desc
               limit $interval_size offset $offset
      </querytext>
</fullquery>


</queryset>
