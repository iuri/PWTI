ad_library {
    Library of Action Manager
	
    @creation-date 2010-11-30
    @author Breno Assunção assuncao.b@gmail.com
}

namespace eval mores 		{}
namespace eval mores::util 	{}



ad_proc -public mores::util::sync_microblog {
 } { 
	Add a account
} {

	db_foreach select_account {
		SELECT query_id,  query_text, isactive, last_request
  		FROM mores_acc_query
		Where isactive = true ;
	} {
	#	set last_id [db_string select_name {select max(post_id) from mores_items3 where query_id = :query_id and source = 'twitter'} -default "1"]
		regsub -all { } $query_text {+} query_text
		regsub -all {'} $query_text {\"} query_text
#		mores::util::sync_twitter -query_text $query_text -query_id $query_id -last_id $last_id
				mores::util::sync_twitter -query_text $query_text -query_id $query_id
	}

}


ad_proc -public mores::util::sync_medias {
 } { 
	Add a account
} {
    db_foreach select_account {
	SELECT query_id,  query_text, isactive, last_request FROM mores_acc_query WHERE isactive = true ;
    } {
	mores::util::sync_social_mention -query_text $query_text -query_id $query_id
    }
}

ad_proc -public mores::util::sync_medias_fb {
 } { 
	Add a account
} {
	db_foreach select_account {
	  SELECT query_id,  query_text, isactive, last_request FROM mores_acc_query WHERE isactive = true ;
	} {
		mores::util::sync_facebook -query_text $query_text -query_id $query_id
	}
}


ad_proc -public mores::util::sync_twitter_users {
    
} { 
	Add a account
} {
    set cont 0
    db_foreach select_account {
	
	SELECT  distinct user_id FROM mores_stat_twt_usr
	
    } {
	incr cont
	ns_log notice "usuário num $cont"
	set url "http://api.twitter.com/1/users/show.json?screen_name=$user_id"
	set url "http://api.twitter.com/1/users/show/$user_id.json"
	if {[catch {set json [ns_httpget $url 60 0]} result]} {
	    set json ""
	} 	
	set json [encoding convertfrom utf-8 $json]
	regsub -all {&nbsp;} $json {} json
	regsub -all {&nbsp;} $json {} json
	regsub -all {\-} $json {$$*} json
	
	set json_list [util::json::parse $json]
	
	set items $json_list
	# set results_list [lindex $results 1]
	# set items [lindex $results_list 1]
	
	regsub -all {\$\$\*} $items {-} items
	
	#foreach one_item $items {
	set one_item $items
	set user_id $user_id
	set user_name $user_id
	set seguidores ""
	set seguindo ""
	set listed ""
	set tweets ""
	set name ""
	set screen_name  ""
	set followers_count  ""
	set friends_count  ""
	set listed_count  ""
	set statuses_count ""
	set name ""
	
	set attr [lindex $one_item 1]
	for {set j 0} {$j < [llength $attr]} { } {		 		
	    set [lindex $attr $j] [lindex $attr [expr $j+1]] 
	    
	    #ns_log notice "VAR: [lindex $attr $j] ******    ([lindex $attr [expr $j+1]])" 
	    incr j
	    incr j
	}
	
	
	set user_id $user_id
	set user_name $screen_name
	set seguidores $followers_count
	set seguindo $friends_count
	set listed $listed_count
	set tweets $statuses_count
	set name $name
	
	
	if {[catch {db_dml insert_item {
	    INSERT INTO mores_users_twitter (
		     user_id, user_name, seguidores, seguindo, listed, tweets, "name"
	    ) VALUES (
		     :user_id,
		     :user_name,
		     :seguidores,
		     :seguindo,
		     :listed,
		     :tweets,
		     :name
						       )
	} }	result]} {
	    #ERROR
	    #ns_log notice " DEu erro   $result - "
	} 	else {
	    #ns_log notice "inseriu o usuário corretamente"
	    
	}
    }
}



ad_proc -public mores::util::sync_twitter {
    {-query_text:required}
    {-query_id:required}
    {-last_id ""}
} { 
	Add a account
} {
	set page 0
	regsub -all { } $query_text {+} query_text
	if {[exists_and_not_null last_id]} {
		set last_id_query "&since_id=$last_id"
	} else {
		set last_id_query ""
	}
	set stop 0
	while {$page < 15 && !$stop} {
		incr page
		set url "http://search.twitter.com/search.json?rpp=100&callback=?&q=$query_text&page=$page$last_id_query"
		
		if {[catch {set json [ns_httpget $url 60 0]} result]} {
		   set json ""
		} 	
		
		#ns_log notice "Valor - [string length $json]"
		if {[string length $json] < 500} {
			ns_log notice "twitter parou $page"
			set stop 1	
			return 0	
		} else {
	#	ns_log notice "twitter buscando $page"
		}
			
		set json [encoding convertfrom utf-8 $json]
	 	regsub -all {&nbsp;} $json {} json
		regsub -all {&nbsp;} $json {} json
		regsub -all {\-} $json {$$*} json

		set json_list [util::json::parse $json]

		set results [lindex $json_list 1]
		set results_list [lindex $results 1]
		set items [lindex $results_list 1]

		regsub -all {\$\$\*} $items {-} items

		foreach one_item $items {
			set from_user_id ""
			set from_user ""
			set profile_image_url ""
			set id ""
			set created_at ""
			set text ""
			set iso_language_code ""
			set to_user_id_str ""
			
			
			set attr [lindex $one_item 1]

			for {set j 0} {$j < [llength $attr]} { } {
		 		
		 		set [lindex $attr $j] [lindex $attr [expr $j+1]] 
				incr j
				incr j
			}

	
			set query_id $query_id 
			set user_id $from_user_id
			set user_nick $from_user
			set user_name $from_user
			set profile_img $profile_image_url
			set post_id $id
			set created_at $created_at
			set updated_at ""
			set title $text
			set text  $text
			set lang $iso_language_code
			set source "twitter"
			set favicon "http://twitter.com/favicon.ico"
			set domain "http://twitter.com"
			set post_url "http://twitter.com/$from_user/statuses/$id"
			set post_img ""
			set to_user $to_user_id_str
			set type "microblog"
			 
			 
			if {[exists_and_not_null last_id] & $post_id < $last_id } {
				## nothing
			} else {
		
				mores::util::items_new  -query_id $query_id \
				 -user_id $user_id \
				 -user_nick $user_nick  \
				 -user_name $user_name  \
				 -profile_img $profile_img  \
				 -post_id $post_id \
				 -created_at $created_at  \
				 -updated_at $updated_at  \
				 -title $title  \
				 -text $text  \
				 -lang $lang  \
				 -source $source  \
				 -favicon $favicon  \
				 -domain $domain  \
				 -post_url $post_url  \
				 -post_img $post_img \
				 -to_user $to_user \
				 -type $type 
			 }
     	}
     }
}


    
ad_proc -public mores::util::sync_facebook {
    {-query_text:required}
    {-query_id:required}
 } { 
	Add a account
} {
  # set query_text "embratur"
  # set query_id 1
	regsub -all { } $query_text {+} query_text
		set url "http://graph.facebook.com/search?limit=1000&type=post&q=$query_text"
		if {[catch {set json [ns_httpget $url 60 0]} result]} {
		   set json ""
		} 	
		if {[string length $json] < 300} {
			return 0
		}
		set json [encoding convertfrom utf-8 $json]
	 	regsub -all {&nbsp;} $json {} json
		regsub -all {&nbsp;} $json {} json
		regsub -all {\-} $json {$$*} json

		set json_list [util::json::parse $json]

		set results [lindex $json_list 1]
		set results_list [lindex $results 1]
		set items [lindex $results_list 1]

		regsub -all {\$\$\*} $items {-} items

		foreach one_item $items {
		
			set attr [lindex $one_item 1]

			set query_id $query_id 
			set user_id ""
			set name ""
			set user_name ""
			set profile_img ""
			set id "0"
			set created_time ""
			set updated_time ""
			set title ""
			set text  ""
			set lang ""
			set source ""
			set message ""
			set domain ""
			set link "http://facebook.com"
			set picture ""
			set description ""
			set type "microblog"
			
			
			for {set j 0} {$j < [llength $attr]} { } {
		 		
		 		set [lindex $attr $j] [lindex $attr [expr $j+1]] 
				incr j
				incr j

				if {[lindex $attr $j] == "from"} {
						set from_list [lindex $attr [expr $j+1]]
						set from_list [lindex $from_list 1]
				
				 		set user_[lindex $from_list 0] [lindex $from_list 1]
				 		set user_[lindex $from_list 2] [lindex $from_list 3]
						
				}
			}

			
			set query_id $query_id 
			set user_id $user_id
			set user_nick $user_name
			set user_name $user_name
			set profile_img $profile_img
			set post_id $id
			set created_at $created_time
			set updated_at $updated_time
			set title $name
			if {[exists_and_not_null message]} {
					set text  $message
			} elseif {[exists_and_not_null description]} {
					set text  $description			
			} else {
					set text $name
			}
			
			set lang $lang
			set source "facebook"
			set favicon "http://facebook.com/favicon.ico"
			set domain "http://facebook.com"
			set post_url $link
			set post_img $picture
			set to_user ""
			set type "microblog"
			 
			 
			
			mores::util::items_new  -query_id $query_id \
			 -user_id $user_id \
			 -user_nick $user_nick  \
			 -user_name $user_name  \
			 -profile_img $profile_img  \
			 -post_id $post_id \
			 -created_at $created_at  \
			 -updated_at $updated_at  \
			 -title $title  \
			 -text $text  \
			 -lang $lang  \
			 -source $source  \
			 -favicon $favicon  \
			 -domain $domain  \
			 -post_url $post_url  \
			 -post_img $post_img \
			 -to_user $to_user \
			 -type $type    	
     }
}
    
ad_proc -public mores::util::sync_social_mention  {
    {-query_text:required}
    {-query_id:required}
} { 
	Add a account
} {
  
regsub -all { } $query_text {+} query_text
		set url "http://api2.socialmention.com/search?q=$query_text&btnG=Search&lang=pt&f=json&src[]=bing&src[]=facebook&src[]=google_blog&src[]=google_buzz&src[]=google_news&src[]=google_video&src[]=msn_social&src[]=msn_video&src[]=mybloglog&src[]=ning&src[]=stumbleupon&src[]=wordpress&src[]=yahoo&src[]=youtube"
		
		
		set url "http://api2.socialmention.com/search?q=$query_text&f=json&t=all&btnG=Search"
		if {[catch {set json [ns_httpget $url 80 0]} result]} {
		   set json ""
		} 	
					
		if {[string length $json] < 500} {
			return 0
		}		
		set json [encoding convertfrom utf-8 $json]
	 	regsub -all {&nbsp;} $json {} json
		regsub -all {&nbsp;} $json {} json
		regsub -all {\-} $json {$$*} json

		set json_list [util::json::parse $json]

		set results [lindex $json_list 1]
		set results_list [lindex $results 3]
		set items [lindex $results_list 1]
		set x [llength $items]
		
		regsub -all {\$\$\*} $items {-} items

		foreach one_item $items {
		
			set attr [lindex $one_item 1]

			for {set j 0} {$j < [llength $attr]} { } {
		 		if {[lindex $attr [expr $j+1]] == "null"} {
		 			set [lindex $attr $j] ""
		 		} else {
		 			set [lindex $attr $j] [lindex $attr [expr $j+1]] 
		 		}
				incr j
				incr j
			}
	
			set query_id $query_id 
			set user_id $user_id
			set user_nick $user
			set user_name $user
			set profile_img $user_image
			set post_id $id
			if {[catch { set created_at [clock_to_ansi $timestamp]}  result]} {
				set created_at "2011-01-01 00:00:00"
			}
			set updated_at ""
			set title $title
			if {[exists_and_not_null description]} {
					set text  $description			
			} else {
					set text $title
			}
			set lang $language
			set source $source
			set favicon $favicon
			set domain $domain
			set post_url $link
			set post_img $image
			set to_user ""
			set type $type
			 
			 if {$source != "twitter" && $source != "facebook"} {
				mores::util::items_new  -query_id $query_id \
				 -user_id $user_id \
				 -user_nick $user_nick  \
				 -user_name $user_name  \
				 -profile_img $profile_img  \
				 -post_id $post_id \
				 -created_at $created_at  \
				 -updated_at $updated_at  \
				 -title $title  \
				 -text $text  \
				 -lang $lang  \
				 -source $source  \
				 -favicon $favicon  \
				 -domain $domain  \
				 -post_url $post_url  \
				 -post_img $post_img \
				 -to_user $to_user \
				 -type $type 
			 }
     }
}

ad_proc -public mores::util::sync_twitter_posts  {
} { 
	sync the tweets
} {
  
  
	set cont 0
	db_foreach select_posts {SELECT user_id, user_nick, user_name, profile_img, post_id, created_at, 
		   text, lang, post_url, type, followers, following, favorites, statuses, verified
	  FROM mores_items_tmp;
	} {
		db_foreach select_query { SELECT query_id, account_id, query_text
		  FROM mores_acc_query where lower(:text) like '%'||lower(trim(both '"' from query_text))||'%'
		} {
			incr cont
			set query_id $query_id 
			set user_id $user_id
			set user_nick $user_nick
			set user_name $user_name
			set profile_img $profile_img
			set post_id $post_id
			set created_at $created_at
			set updated_at ""
			set title ""
			set text  $text
			set lang $lang
			set source "twitter"
			set favicon "http://twitter.com/favicon.ico"
			set domain "http://twitter.com"
			set post_url $post_url
			set post_img ""
			set to_user ""
			set type "microblog"
			 
			mores::util::items_new_with_user  -query_id $query_id \
				 -user_id $user_id \
				 -user_nick $user_nick  \
				 -user_name $user_name  \
				 -profile_img $profile_img  \
				 -post_id $post_id \
				 -created_at $created_at  \
				 -updated_at $updated_at  \
				 -title $title  \
				 -text $text  \
				 -lang $lang  \
				 -source $source  \
				 -favicon $favicon  \
				 -domain $domain  \
				 -post_url $post_url  \
				 -post_img $post_img \
				 -to_user $to_user \
				 -type $type \
				 -followers $followers \
				 -following $following \
				 -favorites $favorites \
				 -statuses $statuses \
				 -verified  $verified
		}
		
		db_dml delete_item { DELETE FROM mores_items_tmp WHERE post_id = :post_id;}
	}

	if {$cont > 0} {
		db_dml delete_item { DELETE from mores_aux where attribute = 'last_update';}
		db_dml insert_item { Insert into mores_aux (attribute, value_date) values('last_update',now());}
	}

}

ad_proc -public mores::util::items_new {
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
} {
	
	

		if {[catch {db_dml insert_item {
				INSERT INTO mores_items3(
				    query_id, user_id, user_nick, user_name, profile_img, post_id, 
				    created_at, updated_at, title, "text", lang, source, favicon, 
				    "domain", post_url, post_img, to_user, "type")
			VALUES (:query_id, 		-- query_id
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
		} }	result]} {
				#ERROR
			   return 1
		
	}
	return 1

}


ad_proc -public mores::util::items_new_with_user {
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
	{-followers}
	{-following}
	{-favorites}
	{-statuses}
	{-verified}    
} { 
	Add item
} {
	
	

		if {[catch {db_dml insert_item {
				INSERT INTO mores_items3(
				    query_id, user_id, user_nick, user_name, profile_img, post_id, 
				    created_at, updated_at, title, "text", lang, source, favicon, 
				    "domain", post_url, post_img, to_user, "type",followers,following,favorites,statuses,verified)
			VALUES (:query_id, 		-- query_id
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
					:type,			--	type 
					:followers,
					:following,
					:favorites,
					:statuses,
					:verified
				)
		} }	result]} {
				#ERROR
			   return 1
		
	}
	return 1

}


ad_proc -public mores::util::sync_twt_users  {
    {-query_text:required}
    {-query_id:required}
} { 
	Add a account
} {
  

		
		set url "http://api2.socialmention.com/search?q=$query_text&f=json&t=all&btnG=Search"
		if {[catch {set json [ns_httpget $url 80 0]} result]} {
		   set json ""
		} 	
					
		set json [encoding convertfrom utf-8 $json]
		set json_list [util::json::parse $json]

		set results [lindex $json_list 1]
		set results_list [lindex $results 3]
		set items [lindex $results_list 1]
		set x [llength $items]
		
		foreach one_item $items {
		
			set attr [lindex $one_item 1]

			for {set j 0} {$j < [llength $attr]} { } {
		 		if {[lindex $attr [expr $j+1]] == "null"} {
		 			set [lindex $attr $j] ""
		 		} else {
		 			set [lindex $attr $j] [lindex $attr [expr $j+1]] 
		 		}
				incr j
				incr j
			}
	
			#INSERT 
     }
}


ad_proc -public mores::util::sync_all {
       
} { 
	Synchronize all statistic items
} {

#
## Limpa todas as tabelas temporárias
#

	db_dml delete_item { delete from mores_stat_graph_tmp;}
	db_dml delete_item { delete from mores_stat_source_query_tmp;}
	db_dml delete_item { delete from mores_stat_source_tmp;}
	db_dml delete_item { delete from mores_stat_twt_usr_tmp;}
	
	
		
## limpa a base de usuários na conta do Ollanta, para remover os usuários japoneses.

	db_dml insert_item {insert into mores_user_block (query_id, user_nick, source)
		select distinct query_id, user_nick, source  from mores_items3  mi
		where query_id in(select query_id from mores_acc_query where account_id = 1935) and lang = 'ja'
		 and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id)
		  }
	db_dml delete_item { delete from mores_items3 where user_nick in (select user_nick from mores_user_block)}  
		  

#
## Inicia o processamento dos dados e alimenta a tabela temporária
#
	
	db_dml insert_item {
			INSERT INTO mores_stat_graph_tmp(account_id, query_id,source, data, date, qtd, tipo, updated_at, lang)
				select account_id, query_id, source, to_char(hour,'HH24') as hour,
					date , qtd,'hora' as tipo, now() as updated_at, lang
				FROM (select a.account_id, maq.query_id, source, date_trunc('day', created_at) as date, 
						date_trunc('hour', created_at) as hour , count(*) as qtd, lang
					FROM mores_items3 mi,mores_accounts a, acs_objects o, mores_acc_query maq	
					WHERE a.account_id = o.object_id and maq.account_id = a.account_id
						AND maq.query_id = mi.query_id and created_at > (o.creation_date -interval '10 days')
					--	and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
					GROUP BY a.account_id, maq.query_id, source,date, hour, lang) as tabela
	}
	ns_log notice "atualizou Querys/hora"
	
	db_dml insert_item {
			INSERT INTO mores_stat_graph_tmp (account_id, query_id,source, data, date, qtd, tipo, updated_at, lang)
			select account_id, query_id, source, to_char(date,'DD/MM') as dia,
				date as data, qtd,'dia' as tipo, now() as updated_at, lang
			FROM (select a.account_id, maq.query_id, source, date_trunc('day', created_at) as date, count(*) as qtd, lang
				FROM mores_items3 mi,mores_accounts a, acs_objects o, mores_acc_query maq	
				WHERE a.account_id = o.object_id and maq.account_id = a.account_id
					AND maq.query_id = mi.query_id and created_at > (o.creation_date -interval '10 days')
				--	and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
				GROUP BY a.account_id, maq.query_id, source, date, lang) as tabela
	}
		
	ns_log notice "atualizou Querys"
	
	
	db_dml insert_item {
			INSERT INTO mores_stat_source_query_tmp (account_id, query_id, source, qtd, updated_at, lang)
			select  account_id, maq.query_id, source, count(*) as qtd, now(), lang
				from mores_items3 mi,mores_acc_query maq 
				where  mi.query_id = maq.query_id and created_at > '2010-11-20'
				--	and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
				group by account_id, maq.query_id, source, lang
			
			
	}
	
	db_dml insert_item {
			INSERT INTO mores_stat_source_tmp (account_id, source, qtd, updated_at, lang)
			SELECT account_id,  source, count(*) as qtd, now(), lang
			FROM (	select distinct on (account_id, user_name, post_id, source, lang) account_id, source, lang
				from mores_items3 mi,mores_acc_query maq 
				where  mi.query_id = maq.query_id   and created_at > '2010-11-20'
				--	and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
			) as tabela
			GROUP BY account_id, source, lang
	}
		
	ns_log notice "atualizou sources"
	
	db_dml insert_item {
		INSERT INTO mores_stat_twt_usr_tmp(account_id,  query_id, user_id, qtd, updated_at, lang)
		SELECT  account_id, maq.query_id,user_name, count(*) as qtd,now(), lang
			FROM mores_items3 mi,mores_acc_query maq , acs_objects o
		 	WHERE user_name is not null and  mi.query_id = maq.query_id   and created_at > (o.creation_date -interval '10 days')
				and source = 'twitter' AND  maq.account_id = o.object_id  
				-- and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
		  	GROUP BY account_id,maq.query_id, user_name, lang
	}
	ns_log notice "atualizou users"




#			select account_id, query_id, source, to_char(hour,'HH24') as hour,
#					date , qtd,'hora' as tipo, now() as updated_at
#				FROM (select a.account_id, maq.query_id, source, date_trunc('day', created_at) as date, 
#						date_trunc('hour', created_at) as hour , count(*) as qtd
#					FROM mores_items3 mi,mores_accounts a, acs_objects o, mores_acc_query maq	
#					WHERE a.account_id = o.object_id and maq.account_id = a.account_id
#						AND maq.query_id = mi.query_id and created_at > (o.creation_date -interval '10 days')
#						and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
#					GROUP BY a.account_id, maq.query_id, source,date, hour) as tabela
					
	db_dml delete_item { delete from mores_stat_graph where tipo = 'hora';}
	
	
	
#	select account_id, query_id, source, to_char(date,'DD/MM') as dia,
#				date as data, qtd,'dia' as tipo, now() as updated_at
#			FROM (select a.account_id, maq.query_id, source, date_trunc('day', created_at) as date , count(*) as qtd
#				FROM mores_items3 mi,mores_accounts a, acs_objects o, mores_acc_query maq	
#				WHERE a.account_id = o.object_id and maq.account_id = a.account_id
#					AND maq.query_id = mi.query_id and created_at > (o.creation_date -interval '10 days')
#					and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
#				GROUP BY a.account_id, maq.query_id, source, date) as tabela
				
				
	db_dml delete_item { delete from mores_stat_graph  where tipo = 'dia';}
		
	
	
	
#	select  account_id, maq.query_id, source, count(*) as qtd, now()
#			from mores_items3 mi,mores_acc_query maq 
#			where  mi.query_id = maq.query_id and created_at > '2010-11-20'
#					and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
#			group by account_id, maq.query_id, source
	
	db_dml delete_item { delete from mores_stat_source_query;}

	
	
	
	
#	SELECT account_id,  source, count(*) as qtd , now()
#			FROM (	select distinct on (account_id, user_name, post_id, source) account_id, source 
#				from mores_items3 mi,mores_acc_query maq 
#				where  mi.query_id = maq.query_id   and created_at > '2010-11-20'
#					and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
#			) as tabela
#			GROUP BY account_id, source
			
	db_dml delete_item { delete from mores_stat_source;}

	
	db_dml delete_item { delete from mores_stat_twt_usr;}
				
#			SELECT  account_id, maq.query_id,user_name, count(*) as qtd,now()
#			FROM mores_items3 mi,mores_acc_query maq , acs_objects o
#		 	WHERE user_name is not null and  mi.query_id = maq.query_id   and created_at > (o.creation_date -interval '10 days')
#				and source = 'twitter' AND  maq.account_id = o.object_id  
#				and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
#		  	GROUP BY account_id,maq.query_id, user_name

	
	
	db_dml insert_item {
			INSERT INTO mores_stat_graph(account_id, query_id,source, data, date, qtd, tipo, updated_at, lang)
				select account_id, query_id,source, data, date, qtd, tipo, updated_at, lang
				FROM mores_stat_graph_tmp;
	}
	ns_log notice "atualizou Querys/hora"
		
	ns_log notice "atualizou Querys"
	
	
	db_dml insert_item {
			INSERT INTO mores_stat_source_query (account_id, query_id, source, qtd, updated_at, lang)
			select account_id, query_id, source, qtd, updated_at, lang
				from mores_stat_source_query_tmp;		
	}
	
	db_dml insert_item {
			INSERT INTO mores_stat_source (account_id, source, qtd, updated_at, lang)
			SELECT account_id, source, qtd, updated_at, lang
			FROM mores_stat_source_tmp;
	}
		
	ns_log notice "atualizou sources"
	
	db_dml insert_item {
		INSERT INTO mores_stat_twt_usr(account_id,  query_id, user_id, qtd, updated_at, lang)
		SELECT account_id,  query_id, user_id, qtd, updated_at, lang
			FROM mores_stat_twt_usr_tmp;
	}
	ns_log notice "atualizou users"

#	db_dml insert_item {
#		INSERT INTO mores_stat_twt(
#			account_id, query_id, lang, user_nick, user_name, user_img, following, 
#			followers, favorites, statuses, verified)
#		SELECT  distinct 1 as acc, query_id, lang,user_nick, user_name, profile_img, following,
#			followers, favorites, statuses, verified
#			FROM mores_items3 where followers is not null;
#	}
	ns_log notice "atualizou users stats"

	db_dml delete_item { delete from mores_stat_graph_tmp;}
	db_dml delete_item { delete from mores_stat_source_query_tmp;}
	db_dml delete_item { delete from mores_stat_source_tmp;}
	db_dml delete_item { delete from mores_stat_twt_usr_tmp;}
	
	
	
	if {[catch {exec /usr/local/pgsql/bin/vacuumdb -U service0 -fz -d mores  } errmsg]} {
		ns_log notice "ERRO: $errmsg"   	    
	} else {
		ns_log notice "Vacuumed ok"   	    
	}
	return 1
}

     

#ALTER TABLE mores_items3 DROP CONSTRAINT mores_items3_pk;
#ALTER TABLE mores_items3
#   ALTER COLUMN post_id DROP NOT NULL;
#ALTER TABLE mores_items3 ADD CONSTRAINT mores_items3_pk2 PRIMARY KEY (query_id, post_id, "domain", "text");
#ALTER TABLE mores_items3 ALTER user_id TYPE bigint;

#ALTER TABLE mores_items3
 #  ALTER COLUMN title DROP NOT NULL;



ad_proc -public mores::util::daemon {
    
} { 
	daemon that monitors if the system is ok
} {
	
	set last_update [db_string select_name "SELECT  EXTRACT(hour FROM now()- value_date)*3600 + EXTRACT(minutes FROM now()- value_date)*60 + EXTRACT(SECONDS FROM now()- value_date) as last_update   FROM mores_aux  where attribute = 'last_update'; " -default "60"]

	if {$last_update > 59} {	
		mores::util::restart_twitter
	}
}
	

ad_proc -public mores::util::restart_twitter {
    
} { 
	restart_monitor
} {
		if {[catch {exec killall -r wget  } errmsg]} {
			ns_log notice "ERRO: $errmsg"   	    
		} 
		
		if {[catch {exec wget http://www.pwti.com.br:8011/watch.php & } errmsg]} {
			ns_log notice "ERRO: $errmsg"   	    
		} 

}
