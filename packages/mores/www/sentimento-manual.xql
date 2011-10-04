<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
   <fullquery name="select_mentions">
     <querytext>
       SELECT mores_post_id, mi.sentimento, user_id, mi.user_nick, user_name, profile_img, to_char(created_at, 'YYYY-MM-DD HH24:MI:SS') as datetime, created_at, mi.query_id, mi.title, text, lang, mi.source, favicon, post_url, post_img
       FROM mores_acc_query maq, acs_objects o, mores_items3 mi
	--       LEFT OUTER JOIN mores_user_block mub ON (mub.query_id = mi.query_id AND mub.source = mi.source)
       WHERE maq.query_id = mi.query_id
       AND maq.account_id = :account_id
       AND maq.account_id = o.object_id
       AND created_at > (o.creation_date -interval '10 days') $sql_date
       AND mi.user_nick not in (SELECT user_nick
	  FROM mores_user_block mub, mores_acc_query maq
	  where account_id = :account_id) --mub.user_nick IS NULL
       [template::list::filter_where_clauses -and -name mentions]
       [template::list::orderby_clause -orderby -name mentions]
       limit $limit
       
       
     </querytext>
    </fullquery>

    <fullquery name="select_langs">
        <querytext>
	  
	 SELECT substr(lang,1,2) as lang, count(*) as qtd
         FROM mores_acc_query maq, acs_objects o, mores_items3 mi
--         LEFT OUTER JOIN mores_user_block mub ON (mub.query_id = mi.query_id and mub.source= mi.source)
         WHERE maq.query_id = mi.query_id
         AND maq.account_id = :account_id
         AND maq.account_id = o.object_id
         AND created_at > (o.creation_date -interval '10 days') $sql_date $sql_source $sql_query_id2 $sql_user
  --       AND mub.user_nick IS NULL
         group by substr(lang,1,2)
         order by 1
	  
	  	  
	</querytext>
    </fullquery>

 </queryset>
