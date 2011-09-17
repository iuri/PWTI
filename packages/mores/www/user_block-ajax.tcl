
ad_page_contract {

block on user_nick in a specific query

    @author assuncao.b@gmail.com
    @date   21th march 2011
} {
	query_id
	source
	user_nick
	return_url
}



 if {[catch {db_dml insert_block {insert into mores_user_block (query_id, user_nick, source) values (:query_id, :user_nick, :source)	} }	result]} {
					#ERROR
				  # return 0
			} 
			ns_log notice "$return_url    Bloqueado o usuário e retornando agora..."
			
ad_returnredirect $return_url
