ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23

} {
	account_id
	{source ""}
	{query_id ""}
	{lang ""}
	{limit "40"}
}

if {$lang == "" } {
	set sql_lang ""
} else {
	set sql_lang " and substr(lang,1,2) = '$lang'"
}

if {$source == "" } {
	set sql_source ""
} else {
	set sql_source " and source = '$source_p'"
}

if {$query_id == "" } {
	set sql_query ""
} else {
	set sql_query " and maq.query_id = $query_id_p"
}

  		ns_log notice " 	select text from mores_items3 mi, mores_acc_query maq
	WHERE maq.query_id = mi.query_id and maq.account_id = $account_id $sql_source $sql_query $sql_lang
	 limit 500;
"


db_foreach select_posts "
	select lower(text) as text from mores_items3 mi, mores_acc_query maq
	WHERE maq.query_id = mi.query_id and maq.account_id = :account_id $sql_source $sql_query $sql_lang
	order by created_at desc
	 limit 500;
" {
	set lista [split $text " "]
	foreach one $lista {
        if { [string length $one] > 3} {
	    	regsub -all {,} $one {} one
	    	regsub -all {\.} $one {} one
	    	regsub -all {\)} $one {} one
	      if {![exists_and_not_null cont($one)]} {
			   set cont($one) 1
			} else {
				incr cont($one)
			 }
         }
	}


}

template::multirow create words_tmp name qtd
template::multirow create words name qtd size color

  foreach x [array names cont] {
	template::multirow append words_tmp $x $cont($x)
   }
   template::multirow sort words_tmp -integer -decreasing qtd
 
 set cont_word 0  
 set size 25
 set color "0000FF"
 template::multirow foreach words_tmp {
 	incr cont_word
 	
	if {$cont_word > 5} {
 		set size 22
 		 set color "00DDFF"
 	}
 	if {$cont_word > 10} {
 		set size 17
 		 set color "000000"
 	}
 	if {$cont_word > 15} {
 		set size 14
 	}
 	if {$cont_word > 20} {
 		set size 10
 	}
 	if {$cont_word < $limit} {
  		template::multirow append words $name $qtd $size $color

  	}	
 } 
