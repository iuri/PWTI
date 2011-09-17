ad_page_contract {
} { 
    	item_id:integer,notnull
	{ category "" }
	{ return_url "" }
	{ attach_p "f" }
}

set user_id [ad_conn user_id]
permission::require_permission -object_id $item_id -privilege read -party_id $user_id
set object_id $item_id
set context_id $object_id
set comment_mime_type "text/html"
set is_live t

ah::requires -sources jquery

ad_form -name comment -export {object_id item_id} -html {id comment-form} -form {
	{name:text(text)
		{label "Nome da empresa"}
	}
	{cnpj:text(text)
		{label "CNPJ"}
		{html {onKeyPress "FormataCnpj(this,event);" OnChange "validaCNPJ(this)" size 18}}
	}
	{email:text(text)
		{label "E-mail"}
		{html {onBlur {ValidaEmail(this)}}}
	}
} -on_submit {
	
	set title $name
	set content "$name,$cnpj,$email"
	set creation_ip [ad_conn peeraddr]
	set comment_id [db_nextval acs_object_id_seq]

	general_comment_new -object_id $object_id -comment_id $comment_id \
		    -title $title -comment_mime_type $comment_mime_type \
		    -context_id $context_id  -user_id $user_id \
		    -is_live $is_live -category $category \
		    -content $content
} -after_submit {
	ad_returnredirect /o/$item_id
}
