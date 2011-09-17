ad_page_contract {
} {
}


db_multirow redes select_redes "SELECT count(*) as qtd,  source
  FROM mores_items3
  group by source
  order by source" {
  	
}


