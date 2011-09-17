-- Implement workflow_case -> workflow_case_pkg change.
--
-- @author Janine Sisk (janine@furfly.net)
--
-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html

create or replace package bt_content
as
    function new (
        content_id          in integer default null,
        content_number      in integer default null,
        package_id      in integer,
        component_id    in integer,
        found_in_version in integer,
        summary         in varchar2,
        user_agent      in varchar2 default '',
        comment_content in varchar2,
        comment_format  in varchar2,
        creation_date   in date default sysdate(),
        creation_user   in integer,
        creation_ip     in varchar2 default null,
        item_subtype    in varchar2 default 'bt_content',
        content_type    in varchar2 default 'bt_content_revision'
    ) return integer;

    procedure delete (
        content_id          in integer
    );

end bt_content;
/
show errors
