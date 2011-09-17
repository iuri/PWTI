ad_page_contract {
  
  @author Breno Assunção (assuncao.b@gmail.com)
  @creation-date 2010-08-23
} {
	account_id
	query_id
	query_text
}

	regsub -all { } $query_text {+} query_text
	regsub -all {"} $query_text {} query_text


#template::head::add_css -href "/resources/mores/buzz.css"
#template::head::add_javascript -src "/resources/mores/buzz.js"

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
