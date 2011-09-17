--
-- The MoReS Package
--
-- @author Breno Assunção (assuncao.b@gmail.com)
-- @creation-date 2010-11-20
--
-- create the object types




--
-- Accounts
--



select acs_object_type__create_type (
    'mores_account', 		-- object_type
    'Account',        		-- pretty_name
    'Accounts',        		-- pretty_plural
    'acs_object',       	-- supertype
    'mores_accounts',   	-- table_name
    'account_id',  			-- id_column
    'mores_account.name',   -- name_method
    'f',
    null,
    null
);


create table mores_accounts (
       account_id	   	integer primary key
						      constraint account_id_fk 
						      references acs_objects (object_id) on delete cascade,
	   name            			varchar NOT NULL,
	   description     			varchar ,
	   num_querys				integer ,
   	   package_id	   			integer NOT NULL
);


create or replace function mores_account__new (
    integer, -- account_id
    varchar, -- name
    varchar, -- description
    integer, -- num_querys
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
)
returns integer as '
declare
    p_account_id  			alias for $1;
    p_name       	  		alias for $2;
    p_description      	    alias for $3;
    p_num_querys			alias for $4;
    p_package_id  	        alias for $5;
    p_creation_date         alias for $6;
    p_creation_user         alias for $7;
    p_creation_ip           alias for $8;
    p_context_id            alias for $9;
  
    v_account_id   integer;
begin

	v_account_id := acs_object__new (
		p_account_id, 	 		 -- object_id
		''mores_account'',  	 -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
	    p_name,                  -- title
        p_package_id             -- package_id
	);

	insert into mores_accounts
	   (account_id, name, description, num_querys, package_id)
	values
	   (v_account_id, p_name, p_description, p_num_querys, p_package_id);

	return v_account_id;
end;
' language 'plpgsql';



create or replace function mores_account__del (
    integer -- account_id
)
returns integer as '
declare
    p_account_id         alias for $1;
begin
    perform acs_object__delete(p_account_id);
	return 0;
end;
' language 'plpgsql';



create or replace function mores_account__edit (
    integer, -- account_id
    varchar, -- name
    varchar, -- description
	integer  -- num_querys
)
returns integer as '
declare
    p_account_id    alias for $1;
    p_name       	alias for $2;
    p_description   alias for $3;
    p_num_querys	alias for $4;
begin
	update mores_accounts
	set name = p_name,
	    description = p_description,
	    num_querys = p_num_querys 	    
	where account_id = p_account_id;
	return 0;
end;
' language 'plpgsql';






----
-- Mores_acc_query
----
select acs_object_type__create_type (
    'mores_query', 		-- object_type
    'Mores query',         -- pretty_name
    'Mores Querys',       -- pretty_plural
    'acs_object',       	-- supertype
    'mores_acc_query',   -- table_name
    'query_id',        	-- id_column
    'mores_query.name',   -- name_method
    'f',
    null,
    null
);

create table mores_acc_query (
		query_id	   		   integer 
			constraint mores_query_id_pk 
			references acs_objects (object_id)  on delete cascade,
		account_id         				integer NOT NULL,
		query_text       				varchar NOT NULL,
		isactive	   					boolean NOT NULL,
		last_request 					timestamp with time zone DEFAULT now(),
		CONSTRAINT mores_acc_query_unique UNIQUE (account_id, query_text),
		CONSTRAINT mores_acc_query_unique_id UNIQUE (query_id),
		CONSTRAINT mores_acc_query_account_id_fk FOREIGN KEY (account_id) REFERENCES mores_accounts (account_id) ON UPDATE NO ACTION ON DELETE CASCADE
);


create or replace function mores_query__new (
    integer, -- query_id
    integer, -- account_id
    varchar, -- query_text
    boolean, -- isactive
    timestamp with time zone, -- last_request
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
)
returns integer as '
declare
    p_query_id   			alias for $1;
    p_account_id       	    alias for $2;
    p_query_text    	    alias for $3;
    p_isactive	 	    	alias for $4;
    p_last_request			alias for $5;
    p_package_id            alias for $6;
    p_creation_date         alias for $7;
    p_creation_user         alias for $8;
    p_creation_ip           alias for $9;
    p_context_id            alias for $10;
  
    v_query_id   integer;
begin

	v_query_id := acs_object__new (
		p_query_id,  			 -- object_id
		''mores_query'',    	 -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
	    p_query_text,                  -- title
        p_package_id             -- package_id
	);

	insert into mores_acc_query
	   (query_id, account_id, query_text, isactive, last_request)
	values
	   (v_query_id, p_account_id, p_query_text, p_isactive, p_last_request);

	return v_query_id;
end;
' language 'plpgsql';



create or replace function mores_query__del (
    integer -- query_id
)
returns integer as '
declare
    p_query_id         alias for $1;
begin
    perform acs_object__delete(p_query_id);
	return 0;
end;
' language 'plpgsql';

CREATE OR REPLACE FUNCTION mores_query__edit( 
 	integer, -- query_id
    varchar -- query_text
)
returns integer as '
declare
    p_query_id    alias for $1;
    p_query_text       	alias for $2;

begin
	update mores_acc_query
	set query_text = p_query_text
	where query_id = p_query_id;
	return 0;
end;
' LANGUAGE 'plpgsql' VOLATILE;

create or replace function mores_query__last_request (
    integer, -- query_id
    timestamp with time zone -- last_request
)
returns integer as '
declare
    p_query_id    		alias for $1;
    p_last_request     	alias for $2;

begin
	update mores_acc_querys
	set last_request = p_last_request
	where query_id = p_query_id;
	return 0;
end;
' language 'plpgsql';




create or replace function mores_query__change_state (
    integer, -- query_id
    boolean -- isactive t or f (true- active false deactive)
)
returns integer as '
declare
    p_query_id    		alias for $1;
    p_isactive     	alias for $2;

begin
	update mores_acc_query
	set isactive = p_isactive
	where query_id = p_query_id;
	return 0;
end;
' language 'plpgsql';


----
-- items
----

create table mores_items (
		query_id    integer NOT NULL,
		user_id    	integer,
		user_nick   varchar,
		user_name   varchar,
		profile_img	varchar,
		post_id     integer,
		created_at 	timestamp with time zone NOT NULL,
		updated_at  timestamp with time zone,
		title       varchar NOT NULL,
		text        varchar NOT NULL,
		lang        varchar,
		source      varchar NOT NULL,
		favicon     varchar,
		domain      varchar NOT NULL,		
		post_url    varchar NOT NULL,
		post_img    varchar,
		to_user     varchar,
		type        varchar,
		CONSTRAINT mores_items_pk PRIMARY KEY (query_id, post_id, domain),
		CONSTRAINT mores_items_query_id_fk FOREIGN KEY (query_id) REFERENCES mores_acc_query (query_id) ON UPDATE NO ACTION ON DELETE CASCADE      	      	      	      	   	
);



create or replace function mores_items__new (
    integer, 					-- query_id
    varchar, 					-- user_id
    integer, 					-- user_nick
    varchar, 					-- user_name   
	varchar, 					--	profile_img	
	integer, 					--	post_id     
	timestamp with time zone, 	--	created_at 	
	timestamp with time zone, 	--	updated_at  
	varchar, 					--	title       
	varchar ,					-- text        
	varchar,					--  lang       
	varchar ,					--  source      
	varchar,					--  favicon    
	varchar ,					-- 	domain      		
	varchar ,					--  post_url    
	varchar,  					--	post_img    
	varchar, 					--	to_user     
	varchar						--	type        
   
)
returns integer as '
declare
	p_query_id			alias for $1;
	p_user_id			alias for $2;
	p_user_nick			alias for $3;
	p_user_name			alias for $4;
	p_profile_img		alias for $5;
	p_post_id			alias for $6;
	p_created_at		alias for $7;
	p_updated_at		alias for $8;
	p_title				alias for $9;
	p_text				alias for $10;
	p_lang				alias for $11;
	p_source			alias for $12;
	p_favicon 			alias for $13;
	p_domain			alias for $14;
	p_post_url			alias for $15;
	p_post_img 			alias for $16;
	p_to_user			alias for $17;
	p_type				alias for $18;
  
begin

	insert into mores_items
	   (query_id,user_id, user_nick, user_name, profile_img, post_id, created_at, updated_at, title, text, lang, source, favicon, domain, post_url, post_img, to_user, type)
	values
	   (p_query_id,	p_user_id, p_user_nick, p_user_name, p_profile_img, p_post_id,p_created_at,p_updated_at, p_title, p_text, p_lang, p_source, p_favicon, p_domain, p_post_url, p_post_img, p_to_user, p_type);

	return 1;
end;
' language 'plpgsql';


create or replace function mores_items__del_from_query_id (
    integer -- query_id
)
returns integer as '
declare
    p_query_id         alias for $1;
begin
    delete from mores_items
    	where query_id = p_query_id;
	return 0;
end;
' language 'plpgsql';





