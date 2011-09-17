--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- xowiki-portlet-portlet-drop.sql
--

-- Deletes a portal datasource for the xowiki portlet factory

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)

-- $Id: xowiki-portlet-portlet-drop.sql,v 1.1 2007/01/31 10:52:47 gustafn Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html
--
-- PostGreSQL port samir@symphinity.com 11 July 2002
--



create function inline_1()
returns integer as '
declare
  ds_id portal_datasources.datasource_id%TYPE;
begin

  select datasource_id into ds_id
      from portal_datasources
     where name = ''xowiki_portlet'';

   if not found then
     RAISE EXCEPTION '' No datasource id found '', ds_id;
     ds_id := null;
   end if;

  if ds_id is NOT null then
    perform portal_datasource__delete(ds_id);
  end if;

	-- drop the hooks
	perform acs_sc_impl_alias__delete (
	       ''portal_datasource'',
	       ''xowiki_portlet'',
	       ''GetMyName''
	);

	perform acs_sc_impl_alias__delete (
	       ''portal_datasource'',
	       ''xowiki_portlet'',
	       ''GetPrettyName''
	);


	perform acs_sc_impl_alias__delete (
	       ''portal_datasource'',
	       ''xowiki_portlet'',
	       ''Link''
	);

	perform acs_sc_impl_alias__delete (
	       ''portal_datasource'',
	       ''xowiki_portlet'',
	       ''AddSelfToPage''
	);

	perform acs_sc_impl_alias__delete (
	       ''portal_datasource'',
	       ''xowiki_portlet'',
	       ''Show''
	);

	perform acs_sc_impl_alias__delete (
	       ''portal_datasource'',
	       ''xowiki_portlet'',
	       ''Edit''
	);

	perform acs_sc_impl_alias__delete (
	       ''portal_datasource'',
	       ''xowiki_portlet'',
	       ''RemoveSelfFromPage''
	);

	-- Drop the binding
	perform acs_sc_binding__delete (
	    ''portal_datasource'',
	    ''xowiki_portlet''
	);

	-- drop the impl
	perform acs_sc_impl__delete (
		''portal_datasource'',
		''xowiki_portlet''
	);
  	
	return 0;
end;' language 'plpgsql';

select inline_1();
drop function inline_1();





