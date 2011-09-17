DROP FUNCTION mores_account__new (integer, varchar,varchar,integer,timestamp with time zone,integer,varchar,integer );

DROP FUNCTION mores_account__del (integer);

DROP FUNCTION mores_account__edit (integer, varchar, varchar);

DROP FUNCTION mores_query__new (integer, integer,varchar,boolean,timestamp with time zone,integer,timestamp with time zone, integer,varchar, integer);

DROP FUNCTION mores_query__del (integer );

DROP FUNCTION mores_query__edit(integer, varchar);

DROP FUNCTION mores_query__last_request (integer, timestamp with time zone);

DROP FUNCTION mores_query__change_state (integer, boolean);

DROP FUNCTION mores_items__new (integer,varchar,integer,varchar,varchar,integer,timestamp with time zone,timestamp with time zone, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar);

DROP FUNCTION mores_items__del_from_query_id (integer);

create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__drop_type (
        ''mores_account'', ''f''
    );

    return null;
end;' language 'plpgsql';
select inline_0();
drop function inline_0 ();

create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__drop_type (
        ''mores_query'', ''f''
    );

    return null;
end;' language 'plpgsql';
select inline_0();
drop function inline_0 ();



drop table mores_accounts cascade;
drop table mores_items;    
drop table mores_acc_query;




   

