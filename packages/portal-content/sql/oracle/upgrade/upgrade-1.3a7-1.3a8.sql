--
-- Added assignee and fix for version to the content add form
--
-- 
--
-- @cvs-id $Id: upgrade-1.3a7-1.3a8.sql,v 1.2 2005/02/24 13:33:03 jeffd Exp $
--

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
	fix_for_version in integer default null,
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
	fix_for_version in integer default null,
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
             creation_user,
	     fix_for_version)
        values
            (v_content_id,
             v_content_number,
             bt_content.new.comment_content,
             bt_content.new.comment_format,
             v_folder_id,
             bt_content.new.package_id,
             bt_content.new.creation_date,
             bt_content.new.creation_user,
	     bt_content.new.fix_for_version);

        -- create the initial revision
        v_revision_id := bt_content_revision.new(
            content_revision_id =>          null,                     
            content_id =>                   v_content_id,                 
            component_id =>             bt_content.new.component_id, 
            found_in_version =>         bt_content.new.found_in_version,
            fix_for_version =>          null,                     
            fixed_in_version =>         bt_content.new.fix_for_version,                     
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
