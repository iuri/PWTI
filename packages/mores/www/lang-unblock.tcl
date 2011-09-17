ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23
} {
	lang
	account_id
}

	 if {[catch {db_dml remove_user_block {delete from mores_lang_acc_block WHERE lang= :lang and account_id = :account_id} }	result]} {
					#ERROR
				  # return 0
			} 		
			
			
	ad_returnredirect "lang-block?account_id=$account_id"
    ad_script_abort
