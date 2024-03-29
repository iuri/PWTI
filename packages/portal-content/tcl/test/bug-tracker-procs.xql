<?xml version="1.0"?>
<queryset>

<fullquery name="_portal-content__project_new.count_projects">
    <querytext>
        select count(*)
        from bt_projects
    </querytext>
</fullquery>

<fullquery name="_portal-content__project_new.new_component_id">
    <querytext>
        select acs_object_id_seq.nextval as component_id
        from dual
    </querytext>
</fullquery>

<fullquery name="_portal-content__project_new.new_component">
    <querytext>
        insert into bt_components
        (component_id, project_id, component_name, maintainer)
        values
        (:component_id, :package_id, 'Foo', :user_id)
    </querytext>
</fullquery>

<fullquery name="_portal-content__project_new.new_content_id">
    <querytext>
        select acs_object_id_seq.nextval as content_id
        from dual
    </querytext>
</fullquery>

</queryset>

