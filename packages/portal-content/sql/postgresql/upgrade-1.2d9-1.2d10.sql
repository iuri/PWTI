-- Fixing the implementation of the bt_content__delete function to work with 
-- renamed workflow_case_pkg__delete function.
--
-- @author Lars Pind (lars@collaboraid.biz)
--
-- $Id: upgrade-1.2d9-1.2d10.sql,v 1.2 2003/08/28 09:45:29 lars Exp $

create or replace function bt_content__delete(
   integer                      -- content_id
) returns integer
as '
declare
    p_content_id                    alias for $1;
    v_case_id                   integer;
    rec                         record;
begin
    -- Every content is associated with a workflow case
    select case_id 
    into   v_case_id 
    from   workflow_cases 
    where  object_id = p_content_id;

    perform workflow_case_pkg__delete(v_case_id);

    -- Every content may have notifications attached to it
    -- and there is one column in the notificaitons datamodel that doesn''t
    -- cascade
    for rec in select notification_id from notifications 
               where response_id = p_content_id loop

        perform notification__delete (rec.notification_id);
    end loop;

    -- unset live & latest revision
--    update cr_items
--    set    live_revision = null,
--           latest_revision = null
--    where  item_id = p_content_id;

    perform content_item__delete(p_content_id);

    return 0;
end;
' language 'plpgsql';
