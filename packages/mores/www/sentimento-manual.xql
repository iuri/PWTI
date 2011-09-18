<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
    <fullquery name="select_mentions">
        <querytext>
	  SELECT base.mores_post_id, base.sentimento, base.user_id, base.user_nick, base.user_name, base.profile_img, to_char(base.created_at, 'YYYY-MM-DD HH24:MI:SS') as datetime, base.created_at, base.query_id, base.title, base.text, base.lang, base.source, base.favicon, base.post_url, base.post_img 
	  FROM ( 
	    SELECT mores_post_id, mi.sentimento, user_id, user_nick, user_name, profile_img, to_char(created_at, 'YYYY-MM-DD HH24:MI:SS') as datetime, created_at, mi.query_id, mi.title, text, lang, source, favicon, post_url, post_img 
	    FROM mores_items3 mi, mores_acc_query maq, acs_objects o 
	    WHERE maq.query_id = mi.query_id 
	    AND maq.account_id = :account_id
	    AND maq.account_id = o.object_id 
	    AND created_at > (o.creation_date -interval '10 days') $sql_date
            [template::list::filter_where_clauses -and -name mentions]
	  ) AS base LEFT OUTER JOIN ( 
	    SELECT user_nick, query_id, source FROM mores_user_block mub 
	  ) sec ON (sec.query_id = base.query_id AND sec.source = base.source) 
	  WHERE sec.user_nick IS NULL 
	  $orderby 
	  LIMIT $limit
        </querytext>
    </fullquery>
    <fullquery name="select_langs">
        <querytext>

	  SELECT substr(base.lang,1,2) as lang, count(base.*) as qtd 
	  FROM ( 
	    SELECT mi.query_id, mi.source, lang 
	    FROM mores_items3 mi, mores_acc_query maq, acs_objects o 
	    WHERE maq.query_id = mi.query_id 
	    AND maq.account_id = :account_id 
	    AND maq.account_id = o.object_id 
	    AND created_at > (o.creation_date -interval '10 days') $sql_date $sql_source $sql_query_id2 $sql_user
	  ) AS base LEFT OUTER JOIN ( 
	    SELECT user_nick, query_id, source FROM mores_user_block mub 
	  ) sec ON (sec.query_id = base.query_id AND sec.source = base.source) 
	  WHERE sec.user_nick IS NULL 
	  GROUP BY substr(lang,1,2)
	  ORDER BY 1

        </querytext>
    </fullquery>

 </queryset>
