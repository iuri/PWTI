--
-- Bug tracker Oracle data model
--
-- Ported from the postgresql version
--   by:  Mark Aufflick (mark@pumptheory.com) <http://pumptheory.com/>
--   for: Collaboraid <http://collaboraid.biz/>

-- all data gets deleted when the applications are uninstantiated


drop package bt_patch;
drop package bt_content_revision;
drop package bt_content;
drop package bt_version;
drop package bt_project;

drop table bt_patch_actions;
drop table bt_patch_content_map;
drop table bt_patches;

begin
    acs_object_type.drop_type('bt_patch', 't');
end;
/
show errors

drop table bt_user_prefs;
drop table bt_contents;

begin
    acs_object_type.drop_type('bt_content', 't');
    content_type.drop_type('bt_content_revision', 't', 'f');
end;
/
show errors

drop table bt_content_revisions;
drop table bt_default_keywords;
drop table bt_versions;
drop table bt_components;
drop table bt_projects;

