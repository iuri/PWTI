
ad_page_contract {

block on user_nick in a specific query

    @author assuncao.b@gmail.com
    @date   21th march 2011
} {
	lang
	account_id
}



 if {[catch {db_dml insert_block {insert into mores_lang_acc_block (lang, account_id) values (:lang, :account_id)	} }	result]} {
					#ERROR
				  # return 0
			} 

			
	ad_returnredirect "lang-block?account_id=$account_id"
