-- Bug tracker search triggers
--
-- @author davis@xarg.net
-- @cvs-id $Id: content-tracker-search-triggers.sql,v 1.1 2004/04/27 12:33:20 jeffd Exp $
--

create or replace function content_tracker_search__itrg ()
returns opaque as '
begin
    if new.parent_id is null then
        perform search_observer__enqueue(new.message_id,''INSERT'');
    else
        perform search_observer__enqueue(forums_message__root_message_id(new.parent_id),''UPDATE'');
    end if;
    return new;
end;' language 'plpgsql';

create or replace function forums_message_search__dtrg ()
returns opaque as '
declare
     v_root_message_id          forums_messages.message_id%TYPE;
begin
    -- if the deleted msg has a parent then its an UPDATE to a thread, otherwise a DELETE.

    if old.parent_id is null then
        perform search_observer__enqueue(old.message_id,''DELETE'');
    else
        v_root_message_id := forums_message__root_message_id(old.parent_id);
        if not v_root_message_id is null then
            perform search_observer__enqueue(v_root_message_id,''UPDATE'');
        end if;
    end if;

    return old;
end;' language 'plpgsql';

create or replace function forums_message_search__utrg ()
returns opaque as '
begin
    perform search_observer__enqueue(forums_message__root_message_id (old.message_id),''UPDATE'');
    return old;
end;' language 'plpgsql';


create trigger forums_message_search__itrg after insert on forums_messages
for each row execute procedure forums_message_search__itrg (); 

create trigger forums_message_search__dtrg after delete on forums_messages
for each row execute procedure forums_message_search__dtrg (); 

create trigger forums_message_search__utrg after update on forums_messages
for each row execute procedure forums_message_search__utrg (); 



-- forums_forums indexing trigger
create or replace function forums_forums_search__itrg ()
returns opaque as '
begin
    perform search_observer__enqueue(new.forum_id,''INSERT'');

    return new;
end;' language 'plpgsql';

create or replace function forums_forums_search__utrg ()
returns opaque as '
begin
    perform search_observer__enqueue(new.forum_id,''UPDATE'');

    return new;
end;' language 'plpgsql';

create or replace function forums_forums_search__dtrg ()
returns opaque as '
begin
    perform search_observer__enqueue(old.forum_id,''DELETE'');

    return old;
end;' language 'plpgsql';



create trigger forums_forums_search__itrg after insert on forums_forums
for each row execute procedure forums_forums_search__itrg (); 

create trigger forums_forums_search__utrg after update on forums_forumss
for each row execute procedure forums_forums_search__utrg (); 

create trigger forums_forums_search__dtrg after delete on forums_forums
for each row execute procedure forums_forums_search__dtrg (); 

