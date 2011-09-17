<?xml version="1.0"?>
<queryset>

<fullquery name="get_content_id_for_number">
      <querytext>
select content_id from bt_contents where content_number = :one_content_number and project_id = :package_id
      </querytext>
</fullquery>

<fullquery name="get_patch_id_for_number">
      <querytext>
select patch_id from bt_patches where patch_number = :patch_number and project_id = :package_id
      </querytext>
</fullquery>

<fullquery name="get_patch_summary">
      <querytext>
select summary from bt_patches where patch_number = :patch_number and project_id = :package_id
      </querytext>
</fullquery>

<fullquery name="component_id_for_patch">
      <querytext>
select component_id from bt_patches where patch_number = :patch_number and project_id = :package_id
      </querytext>
</fullquery>

<fullquery name="content_count_for_mapping">
      <querytext>
select count(*)
         from bt_contents,
              workflow_cases cas,
              workflow_case_fsm cfsm
         where $sql_where_clause
      </querytext>
</fullquery>

</queryset>
