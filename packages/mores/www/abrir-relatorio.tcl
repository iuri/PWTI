ad_page_contract {
} {
	account_id
}


set account_name [db_string select_name {select name from mores_accounts where account_id = :account_id}]

set min_date [db_string select_name "SELECT  to_char(min(date), 'YYYY-MM-DD') FROM mores_stat_graph msg, mores_acc_query maq
	WHERE msg.query_id = maq.query_id and tipo = 'dia' and maq.account_id =:account_id" -default ""]
	
	
db_multirow redes select_redes "SELECT source, sum(qtd) as qtd
		  FROM mores_stat_source
		  where account_id = :account_id
		  group by source
		  order by qtd desc
  		   ;
  		   " {
}

db_multirow users select_users "SELECT user_id as user_name, qtd
  FROM mores_stat_twt_usr
  where account_id = :account_id
  order by qtd desc
  limit 100
;" {
}

db_multirow  querys   select_account "
	SELECT maq.query_id,maq.query_text, COALESCE(qtd,0) as qtd
	  FROM mores_acc_query maq
	  left join (select query_id, sum(qtd) as qtd
	  	from mores_stat_source_query mssq
	  	where 1 = 1 
	  	group by query_id) as dt on ( dt.query_id = maq.query_id)
	WHERE  maq.account_id =:account_id  
	--group by maq.query_id, maq.query_text
	order by 3 desc 
	" {
	}
set css ""

if {$account_id == 1189} {
	set css "/resources/mores/layouts/sebrae/css/css.css"
	template::head::add_css -href "/resources/mores/layouts/sebrae/css/css.css"
}

if {$account_id == 1284} {
	set css "/resources/mores/layouts/jp/css/css.css"
	template::head::add_css -href "/resources/mores/layouts/jp/css/css.css"
}

if {$account_id == 1935} {
	set css "/resources/mores/layouts/ollanta/css/css.css"
	template::head::add_css -href "/resources/mores/layouts/ollanta/css/css.css"
}

template::head::add_javascript   -script "
	function preenche_tudo(campo, grupo) {
		var id = campo.value;
		if (id ==  '0' ) {
			var opcoes = document.getElementsByName(grupo);	
			var i = 0;
			var todos = document.getElementById('q_all').checked;
			if (todos == false) {
				for(i=0; i < opcoes.length; i ++){
					opcoes\[i\].checked = false ;
				}	
			} else {
				for(i=0; i < opcoes.length; i ++){
					opcoes\[i\].checked = true ;
				}
			}
		}
	}
 	"
set package_id [ad_conn package_id]
set extra_css ""
set extra_css [parameter::get -parameter "aditional_css" -package_id $package_id] 	
