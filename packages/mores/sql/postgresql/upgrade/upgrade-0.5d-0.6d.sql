-- /packages/mores/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql
-- Add Column deleted_p to disable queries from the user's GUI
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- creation-date 2011-09-17 

SELECT acs_log__debug('/packages/mores/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql','');



ALTER TABLE mores_acc_query ADD COLUMN deleted_p boolean DEFAULT 'f';