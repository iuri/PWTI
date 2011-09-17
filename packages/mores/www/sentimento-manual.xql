<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
    <fullquery name="select_mentions">
        <querytext>
            SELECT mores_post_id, mi.sentimento, user_id, user_nick, user_name, profile_img, to_char(created_at, 'YYYY-MM-DD HH24:MI:SS') as datetime,
       --to_char(created_at, 'DD  Mon  YYYY') as date, 
       created_at, mi.query_id, mi.title, text, lang, source, favicon, 
        post_url, post_img
  FROM mores_items3 mi, mores_acc_query maq, acs_objects o
  where maq.query_id = mi.query_id and maq.account_id = :account_id  AND maq.account_id = o.object_id
 		 and created_at > (o.creation_date -interval '10 days') $sql_date 
 		 and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
            [template::list::filter_where_clauses -and -name mentions]
	$orderby
  limit $limit
  
        </querytext>
    </fullquery>
    <fullquery name="select_langs">
        <querytext>
            SELECT substr(lang,1,2) as lang, count(*) as qtd
  FROM mores_items3 mi, mores_acc_query maq, acs_objects o
  where maq.query_id = mi.query_id and maq.account_id = :account_id  AND maq.account_id = o.object_id
 		 and created_at > (o.creation_date -interval '10 days') $sql_date $sql_source $sql_query_id2 $sql_user
 		 and user_nick not in (select user_nick from mores_user_block mub where mub.query_id = mi.query_id and mub.source= mi.source)
	group by substr(lang,1,2)
	order by 1
        </querytext>
    </fullquery>

 </queryset>
