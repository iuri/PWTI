--
-- Bug tracker Oracle data model
--


create or replace package bt_project
as
    procedure new (
        package_id      in integer
    );
    procedure del (
        project_id      in integer
    );
    procedure keywords_delete (
        project_id      in integer,
        delete_root_p   in varchar2 default 'f'
    );

end bt_project;
/
show errors

create or replace package bt_version
as
    procedure set_active (
        active_version_id in integer
    );

end bt_version;
/
show errors

create or replace package bt_content
as
    function new (
        content_id          in integer default null,
        content_number      in integer default null,
        package_id      in integer,
        component_id    in integer,
        found_in_version in integer,
        summary         in varchar2,
        user_agent      in varchar2 default null,
        comment_content in varchar2,
        comment_format  in varchar2,
        creation_date   in date default sysdate(),
        creation_user   in integer,
        creation_ip     in varchar2 default null,
        item_subtype    in varchar2 default 'bt_content',
        content_type    in varchar2 default 'bt_content_revision'
    ) return integer;

    procedure del (
        content_id          in integer
    );

    function name (
        content_id        in integer
    ) return varchar2;

end bt_content;
/
show errors

create or replace package bt_content_revision
as
    function new(
        content_revision_id in integer default null, 
        content_id          in integer,
        component_id    in integer,
        found_in_version in integer,
        fix_for_version in integer,
        fixed_in_version in integer,
        resolution      in varchar2,
        user_agent      in varchar2 default null,
        summary         in varchar2,
        creation_date   in date default sysdate(),
        creation_user   in integer,
        creation_ip     in varchar default null
    ) return integer;

end bt_content_revision;
/
show errors

create or replace package bt_patch
as
    function new (
        patch_id        in integer default null,
        project_id      in integer,
        component_id    in integer,
        summary         in varchar2,
        description     in varchar2,
        description_format in varchar2,
        content         in varchar2,
        generated_from_version in integer,
        creation_user   in acs_objects.creation_user%TYPE,
        creation_ip     in varchar2
    ) return integer;

    procedure del (
        patch_id        in integer
    );

    function name (
        patch_id        in integer
    ) return varchar2;

end bt_patch;
/
show errors

create or replace package body bt_project
as
    procedure new (
        package_id      in integer
    )
    is
        v_count                 integer;
        v_instance_name         varchar(300);
        v_creation_user         integer;
        v_creation_ip           varchar(50);
        v_folder_id             integer;
        v_root_folder_id        integer;
        v_keyword_id            integer;
    begin
        select count (*)
        into v_count
        from bt_projects
        where project_id = new.package_id;

        if v_count > 0 then
            return;
        end if;

        -- get instance name for the content folder
        select p.instance_name, o.creation_user, o.creation_ip
        into   v_instance_name, v_creation_user, v_creation_ip
        from   apm_packages p,
               acs_objects o
        where  p.package_id = bt_project.new.package_id
        and    p.package_id = o.object_id;

        select content_item.get_root_folder
        into   v_root_folder_id
        from   dual;

        -- create a root CR folder
        v_folder_id := content_folder.new(
            name => 'content_tracker_' || bt_project.new.package_id,
            label => v_instance_name,
            description => null,
            parent_id => v_root_folder_id,
            context_id => bt_project.new.package_id,
            creation_user => v_creation_user,
            creation_ip => v_creation_ip
        );

        -- Set package_id column. Oddly enoguh, there is no API to set it
        update cr_folders set package_id = bt_project.new.package_id where folder_id = v_folder_id;

        -- register our content type
        content_folder.register_content_type (
            folder_id =>        v_folder_id,
            content_type =>     'bt_content_revision',
            include_subtypes => 't'
        );

        -- create the instance root keyword
        v_keyword_id := content_keyword.new(
            heading =>          v_instance_name,
            description =>      null,
            parent_id =>        null,
            keyword_id =>       null,
            creation_date =>    sysdate(),
            creation_user =>    v_creation_user,
            creation_ip =>      v_creation_ip,
            object_type =>      'content_keyword'
        );

        -- insert the row into bt_projects
        insert into bt_projects 
            (project_id, folder_id, root_keyword_id) 
        values 
            (bt_project.new.package_id, v_folder_id, v_keyword_id);

        -- Create a General component to start with
        insert into bt_components
            (component_id, project_id, component_name)
        values
            (acs_object_id_seq.nextval, bt_project.new.package_id, 'General');

        return;
    end new;

    procedure del (
        project_id      in integer
    )
    is
        v_folder_id         integer;
        v_root_keyword_id   integer;
    begin

        -- get the content folder for this instance
        select folder_id, root_keyword_id
        into   v_folder_id, v_root_keyword_id
        from   bt_projects
        where  project_id = bt_project.del.project_id;

        -- This get''s done in tcl before we are called ... for now
        -- Delete the contents
        -- for rec in select item_id from cr_items where parent_id = v_folder_id
        -- loop
        --      bt_content.del(rec.item_id);
        -- end loop;

        -- Delete the patches
        for rec in (select patch_id from bt_patches where project_id = bt_project.del.project_id)
        loop
             bt_patch.del(rec.patch_id);
        end loop;

        -- delete the content folder
        content_folder.del(v_folder_id);

        -- delete the projects keywords
        bt_project.keywords_delete(
            project_id => project_id,
            delete_root_p => 't'
        );

        -- These tables should really be set up to cascade
        delete from bt_versions where project_id = bt_project.del.project_id;
        delete from bt_components where project_id = bt_project.del.project_id;
        delete from bt_user_prefs where project_id = bt_project.del.project_id;      

        delete from bt_projects where project_id = bt_project.del.project_id;   
    end del;

    procedure keywords_delete (
        project_id      in integer,
        delete_root_p   in varchar2 default 'f'
    )
    is
        v_root_keyword_id     integer;
        v_changed_p           char(1);
    begin
        -- get the content folder for this instance
        select root_keyword_id
        into   v_root_keyword_id
        from   bt_projects
        where  project_id = keywords_delete.project_id;

        -- if we are deleting the root, remove it from the project as well
        if delete_root_p = 't' then
            update bt_projects 
            set    root_keyword_id = null 
            where  project_id = keywords_delete.project_id;
        end if;

        -- delete the projects keywords

        -- Keep looping over all project keywords, deleting all
        -- leaf nodes, until everything has been deleted
        loop
            v_changed_p := 'f';
            for rec in 
              (select keyword_id
               from  (select  keyword_id
                      from    cr_keywords
                      start   with  keyword_id = v_root_keyword_id
                      connect by prior keyword_id = parent_id) q
               where  content_keyword.is_leaf(keyword_id) = 't')
            loop
                if (delete_root_p = 't') or (rec.keyword_id != v_root_keyword_id) then
                    content_keyword.del(rec.keyword_id);
                    v_changed_p := 't';
                end if;
            end loop;
            
            exit when v_changed_p = 'f';
        end loop;

    end keywords_delete;

end bt_project;
/
show errors

create or replace package body bt_version
as
    procedure set_active (
        active_version_id       in integer
    )
    is
        v_project_id            integer;
    begin
        select project_id
        into   v_project_id
        from   bt_versions
        where  version_id = active_version_id;

        if v_project_id is not null then
            update bt_versions set active_version_p='f' where project_id = v_project_id;
        end if;

        update bt_versions set active_version_p='t' where version_id = active_version_id;

        return;
    end;
end bt_version;
/
show errors

create or replace package body bt_content
as
    function new (
        content_id          in integer default null,
        content_number      in integer default null,
        package_id      in integer,
        component_id    in integer,
        found_in_version in integer,
        summary         in varchar2,
        user_agent      in varchar2 default null,
        comment_content in varchar2,
        comment_format  in varchar2,
        creation_date   in date default sysdate(),
        creation_user   in integer,
        creation_ip     in varchar2 default null,
        item_subtype    in varchar2 default 'bt_content',
        content_type    in varchar2 default 'bt_content_revision'
    ) return integer
    is
        v_content_id        integer;
        v_revision_id   integer;
        v_content_number    integer;
        v_folder_id     integer;
    begin
        -- get the content folder for this instance
        select folder_id
        into   v_folder_id
        from   bt_projects
        where  project_id = bt_content.new.package_id;

        -- get content_number
        if content_number is null then
          select nvl(max(content_number),0) + 1
          into   v_content_number
          from   bt_contents
          where  parent_id = v_folder_id;
        else
          v_content_number := content_number;
        end if;

        -- create the content item
        v_content_id := content_item.new(
            name =>             v_content_number, 
            parent_id =>        v_folder_id,   
            item_id =>          bt_content.new.content_id,       
            locale =>           null,            
            creation_date =>    bt_content.new.creation_date,  
            creation_user =>    bt_content.new.creation_user,  
            context_id =>       v_folder_id,      
            creation_ip =>      bt_content.new.creation_ip,    
            item_subtype =>     bt_content.new.item_subtype,   
            content_type =>     bt_content.new.content_type,   
            title =>            null,             
            description =>      null,             
            nls_language =>     null,             
            mime_type =>        null,             
            data =>             null              
        );

        -- create the item type row
        insert into bt_contents
            (content_id,
             content_number,
             comment_content,
             comment_format,
             parent_id,
             project_id,
             creation_date,
             creation_user)
        values
            (v_content_id,
             v_content_number,
             bt_content.new.comment_content,
             bt_content.new.comment_format,
             v_folder_id,
             bt_content.new.package_id,
             bt_content.new.creation_date,
             bt_content.new.creation_user);

        -- create the initial revision
        v_revision_id := bt_content_revision.new(
            content_revision_id =>          null,                     
            content_id =>                   v_content_id,                 
            component_id =>             bt_content.new.component_id, 
            found_in_version =>         bt_content.new.found_in_version,
            fix_for_version =>          null,                     
            fixed_in_version =>         null,                     
            resolution =>               null,                     
            user_agent =>               bt_content.new.user_agent,    
            summary =>                  bt_content.new.summary,       
            creation_date =>            bt_content.new.creation_date,
            creation_user =>            bt_content.new.creation_user,
            creation_ip =>              bt_content.new.creation_ip  
        );

        return v_content_id;
    end new;

    procedure del (
        content_id          in integer
    )
    is
        v_case_id       integer;
        foo             integer;
    begin
        -- Every content is associated with a workflow case
        select case_id into v_case_id
        from workflow_cases
        where object_id = bt_content.del.content_id;

        foo := workflow_case_pkg.del(v_case_id);
        
        -- Every content may have notifications attached to it
        -- and there is one column in the notificaitons datamodel that doesn't
        -- cascade
        for rec in (select notification_id from notifications where response_id = bt_content.del.content_id)
        loop
            notification.del (rec.notification_id);
        end loop;

        acs_object.del(content_id);
        
        return;
    end del;

    function name (
        content_id         in integer
    ) return varchar2
    is
        v_name          bt_contents.summary%TYPE;
    begin
        select summary
        into   v_name
        from   bt_contents
        where  content_id = name.content_id;

        return v_name;
    end name;

end bt_content;
/
show errors

create or replace package body bt_content_revision
as
    function new(
        content_revision_id in integer default null, 
        content_id          in integer,
        component_id    in integer,
        found_in_version in integer,
        fix_for_version in integer,
        fixed_in_version in integer,
        resolution      in varchar2,
        user_agent      in varchar2 default null,
        summary         in varchar2,
        creation_date   in date default sysdate(),
        creation_user   in integer,
        creation_ip     in varchar default null
    ) return integer
    is

        v_revision_id               integer;
    begin
        -- create the initial revision
        v_revision_id := content_revision.new(
            title =>            summary,              -- title
            description =>      null,                   -- description
            publish_date =>     sysdate(),                  -- publish_date
            mime_type =>        null,                   -- mime_type
            nls_language =>     null,                   -- nls_language        
            text =>         null,                   -- new_data
            item_id =>          content_id,               -- item_id
            revision_id =>      content_revision_id,      -- revision_id
            creation_date =>    creation_date,        -- creation_date
            creation_user =>    creation_user,        -- creation_user
            creation_ip =>      creation_ip           -- creation_ip
        );

        -- insert into the content-specific revision table
        insert into bt_content_revisions 
            (content_revision_id, component_id, resolution, user_agent, found_in_version, fix_for_version, fixed_in_version)
        values
            (v_revision_id, bt_content_revision.new.component_id, bt_content_revision.new.resolution, bt_content_revision.new.user_agent, bt_content_revision.new.found_in_version, bt_content_revision.new.fix_for_version, bt_content_revision.new.fixed_in_version);

        -- make this revision live
        content_item.set_live_revision(v_revision_id);

        -- update the cache
        update bt_contents
        set    live_revision_id = v_revision_id,
               summary = bt_content_revision.new.summary,
               component_id = bt_content_revision.new.component_id,
               resolution = bt_content_revision.new.resolution,
               user_agent = bt_content_revision.new.user_agent,
               found_in_version = bt_content_revision.new.found_in_version,
               fix_for_version = bt_content_revision.new.fix_for_version,
               fixed_in_version = bt_content_revision.new.fixed_in_version
        where  content_id = bt_content_revision.new.content_id;

        return v_revision_id;
    end new;

end bt_content_revision;
/
show errors

 
create or replace package body bt_patch
as
    function new (
        patch_id        in integer default null,
        project_id      in integer,
        component_id    in integer,
        summary         in varchar2,
        description     in varchar2,
        description_format in varchar2,
        content         in varchar2,
        generated_from_version in integer,
        creation_user   in acs_objects.creation_user%TYPE,
        creation_ip     in varchar2
    ) return integer
    is
        v_patch_id      integer;
        v_patch_number  integer;
        v_action_id     integer;
    begin
        v_patch_id := acs_object.new(
            object_id   => patch_id,
            object_type => 'bt_patch',
            context_id  => project_id,
            creation_ip => creation_ip,
            creation_user => creation_user
        );

        select nvl(max(patch_number),0) +1
        into   v_patch_number
        from   bt_patches
        where  project_id = new.project_id;

        insert into bt_patches
            (patch_id, 
             project_id, 
             component_id, 
             summary, 
             content, 
             generated_from_version,
             patch_number)
        values
            (v_patch_id, 
             project_id, 
             component_id, 
             summary, 
             content, 
             generated_from_version,
             v_patch_number);

        select acs_object_id_seq.nextval into v_action_id from dual;

        insert into bt_patch_actions
            (action_id, patch_id, action, actor, comment_text, comment_format)
        values
            (v_action_id, v_patch_id, 'open', creation_user, description, description_format);

        return v_patch_id;
    end  new;

    function name (
        patch_id         in integer
    ) return varchar2
    is
        v_name          bt_patches.summary%TYPE;
    begin
        select summary
        into   v_name
        from   bt_patches
        where  patch_id = name.patch_id;

        return v_name;
    end name;


    procedure del (
        patch_id          in integer
    )
    is
    begin
        acs_object.del( patch_id );

        return;
    end del;

end bt_patch;
/
show errors

