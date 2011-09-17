ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23
} {
	query_id
	account_id
	user_nick
	source
}

	 if {[catch {db_dml remove_user_block {delete from mores_user_block WHERE source= :source and user_nick = :user_nick and query_id = :query_id } }	result]} {
					#ERROR
				  # return 0
			} 		
			
			
	ad_returnredirect "user-block?account_id=$account_id"
    ad_script_abort
