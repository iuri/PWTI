-- Correcting the 0.9d-1.2d2 upgrade that left the temporary definition
-- of bt_content__new
--
-- @author Peter Marklund

create or replace function bt_content__new(
    integer,     -- content_id
    integer,     -- content_number
    integer,     -- package_id
    integer,     -- component_id
    integer,     -- found_in_version
    varchar,     -- summary
    varchar,     -- user_agent
    text,        -- comment_content
    varchar,     -- comment_format
    timestamptz, -- creation_date
    integer,     -- creation_user
    varchar,     -- creation_ip
    varchar,     -- item_subtype
    varchar      -- content_type
) returns int
as '
declare
    p_content_id                    alias for $1;
    p_content_number                alias for $2;
    p_package_id                alias for $3;
    p_component_id              alias for $4;
    p_found_in_version          alias for $5;
    p_summary                   alias for $6;
    p_user_agent                alias for $7;
    p_comment_content           alias for $8;
    p_comment_format            alias for $9;
    p_creation_date             alias for $10;
    p_creation_user             alias for $11;
    p_creation_ip               alias for $12;
    p_item_subtype              alias for $13;
    p_content_type              alias for $14;

    v_content_id                    integer;
    v_revision_id               integer;
    v_content_number                integer;
    v_folder_id                 integer;
begin
    -- get the content folder for this instance
    select folder_id
    into   v_folder_id
    from   bt_projects
    where  project_id = p_package_id;

    -- get content_number
    if p_content_number is null then
      select coalesce(max(content_number),0) + 1
      into   v_content_number
      from   bt_contents
      where  parent_id = v_folder_id;
    else
      v_content_number := p_content_number;
    end if;

    -- create the content item
    v_content_id := content_item__new(
        v_content_number,              -- name
        v_folder_id,               -- parent_id
        p_content_id,                  -- item_id
        null,                      -- locale        
        p_creation_date,           -- creation_date
        p_creation_user,           -- creation_user
        v_folder_id,               -- context_id
        p_creation_ip,             -- creation_ip
        p_item_subtype,            -- item_subtype
        p_content_type,            -- content_type
        null,                      -- title
        null,                      -- description
        null,                      -- mime_type
        null,                      -- nls_language
        null                       -- data
    );

    -- create the item type row
    insert into bt_contents
        (content_id, content_number, comment_content, comment_format, parent_id, project_id, creation_date, creation_user)
    values
        (v_content_id, v_content_number, p_comment_content, p_comment_format, v_folder_id, p_package_id, p_creation_date, p_creation_user);

    -- create the initial revision
    v_revision_id := bt_content_revision__new(
        null,                      -- content_revision_id
        v_content_id,                  -- content_id
        p_component_id,            -- component_id
        p_found_in_version,        -- found_in_version
        null,                      -- fix_for_version
        null,                      -- fixed_in_version
        null,                      -- resolution
        p_user_agent,              -- user_agent
        p_summary,                 -- summary
        p_creation_date,           -- creation_date
        p_creation_user,           -- creation_user
        p_creation_ip              -- creation_ip
    );

    return v_content_id;
end;
' language 'plpgsql';
