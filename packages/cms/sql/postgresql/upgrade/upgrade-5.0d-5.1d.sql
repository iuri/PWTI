-- 
-- packages/cms/sql/postgresql/upgrade/upgrade-5.0d-5.1d.sql
-- 
-- @author Stan Kaufman (skaufman@epimetrics.com)
-- @creation-date 2005-10-04
-- @cvs-id $Id: upgrade-5.0d-5.1d.sql,v 1.1 2005/10/04 22:05:51 skaufman Exp $
--

-- adds package_id to call to content_item__new
create or replace function content_module__new (varchar,varchar,varchar,integer,integer,integer,integer,timestamptz,integer,varchar,varchar)
returns integer as '
declare
  p_name                        alias for $1;  
  p_key                         alias for $2;  
  p_root_key                    alias for $3;  
  p_sort_key                    alias for $4;  
  p_parent_id                   alias for $5;  -- null  
  p_package_id                  alias for $6;
  p_object_id                   alias for $7;  -- null
  p_creation_date               alias for $8;  -- now()
  p_creation_user               alias for $9;  -- null
  p_creation_ip                 alias for $10;  -- null
  p_object_type                 alias for $11; -- ''content_module''
  v_module_id                   integer;       
begin
  v_module_id := content_item__new(
      p_name,
      p_parent_id,
      p_object_id,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_module'',
      p_object_type,
      null,
      null,
      ''text/plain'',
      null,
      null,
      ''file'',
      p_package_id
  );

  insert into cm_modules
    (module_id, key, name, root_key, sort_key, package_id)
  values
    (v_module_id, p_key, p_name, p_root_key, p_sort_key, p_package_id);

  return v_module_id;

end;' language 'plpgsql';
