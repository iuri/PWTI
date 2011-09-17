--
-- packages/acs-mail/sql/postgresql/acs-mail-nt-drop.sql
--
-- @author Vinod Kurup <vkurup@massmed.org>
-- @creation-date 2001-07-05
-- @cvs-id $Id: acs-mail-nt-drop.sql,v 1.5 2004/03/12 18:48:51 jeffd Exp $
--

-- FIXME: This script has NOT been tested! - vinodk

drop function acs_mail_nt__post_request(integer,integer,boolean,varchar,text,integer);
drop function acs_mail_nt__post_request(integer,integer,varchar,text);
drop function acs_mail_nt__post_request(integer,integer,boolean,varchar,text,integer,integer);
drop function acs_mail_nt__post_request(integer,integer,varchar,text,integer);
drop function acs_mail_nt__cancel_request (integer);
drop function acs_mail_nt__expand_requests ();
drop function acs_mail_nt__update_requests ();
drop function acs_mail_nt__process_queue (varchar,integer);
drop function acs_mail_nt__schedule_process (numeric,varchar,integer);

