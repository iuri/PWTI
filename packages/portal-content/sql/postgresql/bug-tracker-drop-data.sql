-- Drop all contents in the content tracker

create function inline_0 ()
returns integer as '
declare
    v_content_id    integer;
begin
    loop        
        select min(content_id) into v_content_id from bt_contents;
        exit when not found or v_content_id is null;
        perform bt_content__delete(v_content_id);
    end loop;

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();
