ad_library {
    Library of Action Manager
	
    @creation-date 2010-11-30
    @author Breno Assunção assuncao.b@gmail.com
}

namespace eval mores 			{}
namespace eval mores::account 	{}
namespace eval mores::items		{}


ad_proc -public mores::account_new {
    {-name:required}
    {-description:required}
    {-num_querys:required}
} { 
	Add a account
} {
	set package_id 	  [ad_conn package_id]
	set creation_user [ad_conn user_id]
	set creation_ip   [ad_conn peeraddr]

	set account_id [db_string create_account {
		select  mores_account__new (
			null, -- account_id
			:name, -- name
			:description, -- description
			:num_querys, -- num_querys
			:package_id, -- package_id
			now(), -- creation_date
			:creation_user, -- creation_user
			:creation_ip, -- creation_ip
			:package_id  -- context_id
		)
	}]	
	return $account_id
}

ad_proc -public mores::account_del {
     {-account_id:required}
} {
     delete a account
} {
    return [db_string delete_account {
            select mores_account__del(:account_id)
        }]
}

	
	
ad_proc -public mores::account_edit {
    {-account_id}
    {-name:required}
    {-description:required}
    {-num_querys:required}
} { 
	Edit Account
} {

	return [db_string edit_account {
		select mores_account__edit (
			:account_id, -- account_id
			:name, -- name
			:description, -- description
			:num_querys  -- num_querys	
		)
	}]	

}

ad_proc -public mores::query_new {
	{-account_id ""}
	{-query_text:required}
    {-isactive:required}    
} { 
	Add query
} {
	set package_id 	  [ad_conn package_id]
	set creation_user [ad_conn user_id]
	set creation_ip   [ad_conn peeraddr]


	
	set query_id [db_string create_query {
	    select mores_query__new (
				     null,			-- account_id
				     :account_id, 		-- account_id
				     :query_text, 		-- query_text
				     :isactive, 		-- isactive
				     null , 			-- last_request
				     :package_id,		-- package_id
				     now(), 			-- creation_date
				     :creation_user, 	        -- creation_user
				     :creation_ip, 		-- creation_ip
				     :package_id		-- context_id
		)
	}]	
    
	return $query_id
}



ad_proc -public mores::query_del {
    {-query_id:required}
    {-account_id:required}
} {
     delete query
} {

    #set retorno [db_string delete_query { select mores_query__del(:query_id)}]
    set retorno [db_dml delete_query { 
	UPDATE mores_acc_query SET isactive = 'f', deleted_p = 't' 
	WHERE account_id = :account_id AND query_id = :query_id
    }]

    mores::util::restart_twitter
    return $retorno
}


ad_proc -public mores::query_edit {
    {-query_id:required}
    {-query_text:required}

} { 
	Edit a query
} {
	set retorno [db_string edit_query {
		select mores_query__edit( 
		 	:query_id, -- query_id
			:query_text -- query_text
		)
	}]	
    mores::util::restart_twitter
    return $retorno
		
}

ad_proc -public mores::query_last_request {
 	{-query_id:required}
	{-last_request:required}
} { 
	Edit the last request of a query
} {
	return [db_string change_last_request {
		select mores_query__last_request (
			:query_id, 		-- query_id
			:last_request 	-- last_request
		)
	}]	
}


ad_proc -public mores::query_change_state {
 	{-query_id:required}
	{-isactive:required}
} { 
	Edit the state of a Query
} {
	set retorno [db_string change_state {
		select mores_query__change_state (
				:query_id , -- query_id
				:isactive -- isactive t or f (true- active false deactive)
		)
	}]	
    mores::util::restart_twitter
    return $retorno

}




# Items :


ad_proc -public mores::items_new {
    {-query_id}
	{-user_id}
	{-user_nick}
	{-user_name}
	{-profile_img}
	{-post_id}
	{-created_at}
	{-updated_at}
	{-title}
	{-text}
	{-lang}
	{-source}
	{-favicon}
	{-domain}
	{-post_url}
	{-post_img}
	{-to_user}
	{-type}
    
} { 
	Add item

	return [db_string create_location {
		select mores_items__new (
			:query_id, 		-- query_id
			:user_id, 		-- user_id
			:user_nick, 	-- user_nick
			:user_name , 	-- user_name   
			:profile_img, 	--	profile_img	
			:post_id, 		--	post_id     
			:created_at, 	--	created_at 	
			:updated_at , 	--	updated_at  
			:title, 		--	title       
			:text ,			-- text        
			:lang,			--  lang       
			:source ,		--  source      
			:favicon,		--  favicon    
			:domain ,		-- 	domain      		
			:post_url  ,	--  post_url    
			:post_img,  	--	post_img    
			:to_user, 		--	to_user     
			:type			--	type 
		)
	}]	


}

ad_proc -public mores::items_del_from_query_id {
	{-query_id}   
} { 
	Delete items from a specific query_id
} {
	return [db_string items_del_from_query {
		select mores_items__del_from_query_id (
			:query_id -- query_id
		)
	}]	

}



