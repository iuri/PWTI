<?xml version="1.0"?>
<queryset>

<fullquery name="portal_content::install::package_upgrade.select_project_ids">
    <querytext>
        select project_id
        from bt_projects
    </querytext>
</fullquery>

<fullquery name="portal_content::install::package_upgrade.select_case_ids">
    <querytext>
      select wc.case_id
      from workflow_cases wc, bt_contents b
      where wc.object_id = b.content_id
    </querytext>
</fullquery>

</queryset>
