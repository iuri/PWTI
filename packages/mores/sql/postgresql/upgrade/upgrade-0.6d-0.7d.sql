-- /packages/mores/sql/postgresql/upgrade/upgrade-0.6d-0.7d.sql

SELECT acs_log__debug ('/packages/mores/sql/postgresql/upgrade/upgrade-0.6d-0.7d.sql', '');


ALTER TABLE mores_stat_twt_usr ADD COLUMN twt_user_id character varying;

UPDATE mores_stat_twt_usr SET twt_user_id = user_id;


ALTER TABLE mores_stat_twt_usr DROP COLUMN user_id;

ALTER TABLE mores_stat_twt_usr ADD COLUMN user_id integer;

CREATE SEQUENCE mores_stat_twt_usr_user_id_seq;
 
UPDATE mores_stat_twt_usr SET user_id = NEXTVAL('mores_stat_twt_usr_user_id_seq');

ALTER TABLE mores_stat_twt_usr ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE mores_stat_twt_usr ALTER COLUMN twt_user_id SET NOT NULL;


-- Remove special chars
-- UPDATE mores_stat_twt_usr SET user_id = REGEXP_REPLACE(user_id,E'[^\x01-\x7E]', ' ', 'g') WHERE user_id ~ E '[^\x01-\x7E]';



CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS integer AS '
DECLARE

	row	record;
BEGIN

	FOR row IN 
	    	SELECT user_id FROM mores_stat_twt_usr
 
	LOOP
		
		 RAISE NOTICE ''user_id  = %'', row.user_id;
		--  REGEXP _REPLACE (row.user_id 
		 RAISE NOTICE ''user_id  = %'', row.user_id;
		
	END LOOP;

	RETURN 0;
END;' language 'plpgsql';


-- SELECT inline_0 ();
DROP FUNCTION inline_0 ();


