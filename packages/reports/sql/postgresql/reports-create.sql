----
--- Create data model
----



CREATE TABLE reports
(
  report_id int4 NOT NULL,
  report_name text NOT NULL,
  table_name varchar NOT NULL,
  CONSTRAINT reports_report_id PRIMARY KEY (report_id)
)
WITH (OIDS=TRUE);
ALTER TABLE reports OWNER TO service0;


CREATE TABLE reports_attributes
(
  attribute_id int4 NOT NULL,
  report_id int4 NOT NULL
			constraint reports_atributes_reports_report_id_fk
            references reports (report_id)
			ON UPDATE NO ACTION ON DELETE CASCADE,
  type varchar NOT NULL,
  value varchar NOT NULL,
  pretty_name varchar NOT NULL,
  reference varchar,
  CONSTRAINT reports_attributes_attribute_id PRIMARY KEY (attribute_id)
)
WITH (OIDS=TRUE);
ALTER TABLE reports_attributes OWNER TO service0;


select acs_object_type__create_type (
    'reports_report',           -- object_type
    'Report',          			-- pretty_name
    'Reports',         			-- pretty_plural
    'acs_object',           	-- supertype
    'reports',          		-- table_name
    'report_id',        		-- id_column
    'report.name',      		-- name_method
    'f',
    null,
    null
);

select acs_object_type__create_type (
    'reports_attribute',      -- object_type
    'Report Attribute',       -- pretty_name
    'Report Atributes',    	  -- pretty_plural
    'acs_object',             -- supertype
    'reports_atributes',      -- table_name
    'type_id',                -- id_column
    'reports_atribute.name',  -- name_method
    'f',
    null,
    null
);

create or replace function reports__new (
    integer, -- report_id
    varchar, -- report_name
    varchar, -- table
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
)
returns integer as '
declare
    p_report_id  	        alias for $1;
    p_report_name           alias for $2;
    p_table_name            alias for $3;
    p_package_id            alias for $4;
    p_creation_date         alias for $5;
    p_creation_user         alias for $6;
    p_creation_ip           alias for $7;
    p_context_id            alias for $8;
    v_report_id             integer;
begin

	v_report_id := acs_object__new (
		p_report_id,	         -- object_id
		''reports_report'',      -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
        p_report_name,           -- title
        p_package_id             -- package_id
	);

	insert into reports
	   (report_id, report_name, table_name)
	values
	   (v_report_id, p_report_name, p_table_name);

	return v_report_id;
end;
' language 'plpgsql';

create or replace function reports_attributes__new (
	integer, -- attribute_id
    integer, -- report_id
    varchar, -- type
    varchar, -- value
    varchar, -- pretty_name
    varchar, -- reference
	integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
)
returns integer as '
declare
    p_attribute_id	        alias for $1;
    p_report_id  	        alias for $2;
    p_type		            alias for $3;
    p_value  	            alias for $4;
	p_pretty_name			alias for $5;
	p_reference				alias for $6;
    p_package_id            alias for $7;
    p_creation_date         alias for $8;
    p_creation_user         alias for $9;
    p_creation_ip           alias for $10;
    p_context_id            alias for $11;
    v_attribute_id          integer;
begin

	v_attribute_id := acs_object__new (
		p_attribute_id,	         -- object_id
		''reports_attribute'',   -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
        p_pretty_name,           -- title
        p_package_id             -- package_id
	);

	insert into reports_attributes
	   (attribute_id, report_id, type, value, pretty_name, reference)
	values
	   (v_attribute_id, p_report_id, p_type, p_value, p_pretty_name, p_reference);

	return v_attribute_id;
end;
' language 'plpgsql';


create or replace function reports__edit (
    integer, -- report_id
    varchar, -- report_name
    varchar -- table
)
returns integer as '
declare
    p_report_id  	        alias for $1;
    p_report_name           alias for $2;
    p_table_name            alias for $3;
begin

	update reports set report_name = p_report_name, table_name = p_table_name where report_id = p_report_id;
	return p_report_id;
end;
' language 'plpgsql';

create or replace function reports_attributes__edit (
	integer, -- attribute_id
    integer, -- report_id
    varchar, -- type
    varchar, -- value
    varchar, -- pretty_name
    varchar -- reference
)
returns integer as '
declare
    p_attribute_id	        alias for $1;
    p_report_id  	        alias for $2;
    p_type		            alias for $3;
    p_value  	            alias for $4;
	p_pretty_name			alias for $5;
	p_reference				alias for $6;
begin

	update reports_attributes set type = p_type, value = p_value, pretty_name = p_pretty_name, reference = p_reference 
	where attribute_id = p_attribute_id;
	return p_attribute_id;
end;
' language 'plpgsql';


CREATE OR REPLACE FUNCTION reports__del(integer)
  RETURNS integer AS '
declare
    p_report_id               alias for $1;
begin
    perform acs_object__delete(p_report_id);

    return 0;

end;'
  LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION reports_attributes__del(integer)
  RETURNS integer AS '
declare
    p_attribute_id             alias for $1;
begin
    perform acs_object__delete(p_attribute_id);

    return 0;

end;'
  LANGUAGE 'plpgsql' VOLATILE;





