
ad_page_contract {

    Display a questionnaire for one survey.

    @author assuncao.b@gmail.com
    @date   12th April 2010
} {
    {sentimento "0"}
    {mores_post_id}
}

#ns_log notice "######################################################## Save goal"
#ns_log notice "$initial_response_id * $sdt_code * $financial_goal * $goal * $period * "

 if {[catch {db_dml insert_sentimento {UPDATE mores_items3 set sentimento = :sentimento where mores_post_id = :mores_post_id
			} }	result]} {
					#ERROR
				  # return 0
			} 
	 if {[catch {db_dml insert_sentimento {INSERT INTO mores_sentimento(query_id, lang, source, mores_post_id, sentimento)
				  SELECT query_id, lang, source, mores_post_id, sentimento  FROM mores_items3 WHERE mores_post_id = :mores_post_id
			} }	result]} {
					#ERROR
				  # return 0
			} 		
			


if { $sentimento == 1} {
	set result_msg "<div style=\"background-color: greenYellow;\">POSITIVO </div>"
} elseif { $sentimento == 2} {
	set result_msg "<div style=\"background-color: Yellow;\">NEUTRO</div>"
} elseif { $sentimento == 3} {
	set result_msg "<div style=\"background-color: red;\">NEGATIVO</div>"
} else { 
	set result_msg "<div style=\"background-color: blue;\">DIVULGAÇÃO</div>"
} 


ns_return 200 "text/html; charset=utf-8" $result_msg
