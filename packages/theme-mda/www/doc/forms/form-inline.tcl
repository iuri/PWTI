
ad_page_contract {
    A Sample Zen Form
    inline-form class
   
    @creation-date 2/1/2007
    @cvs-id $Id: form-inline.tcl,v 1.1.2.2 2007/03/03 21:07:09 avni Exp $
} {
    {zen_id:naturalnum,optional 42}
}
ad_form -name "your_zen_level" -method post -html {enctype multipart/form-data class inline-form} -fieldset {{title "T1" class "C1"} \
														 "<b>Form using inline-form class</b>"} \
    -form {
    {zen_id:key}
    {zen_attachment:text(file),optional\
	 {label "template::widget::attachment"}}
    {zen_block:text(block)\
	 {label "template::widget::block"}\
	 {options {{{OneItem 1}} {"a label" {{onlyOne}}} {"algo1" {{name1 f one}}} {"algo2" {{name2 t one}}}}}}
    {zen_button:text(button)\
	 {label "template::widget::button"}\
	 {value "Click if you have reached Nirvana"}}
    {zen_category:text(category)\
	 {label "template::widget::category"}\
	 {value "Category"}\
	 {category_tree_id 69519}}
    {zen_checkbox:text(checkbox),multiple,optional\
	 {label "template::widget::checkbox"}\
	 {options {{Uncertain u} {"Somewhat zen" sz} {"Chaotic" ch} {"Calm" c} {"Fully zen" fz}}}} 
    {zen_comment:text(comment)\
	 {label "template::widget::comment"}\
	 {value "Please enter your comments here on what reaching nirvana will mean for you."}\
	 {html {rows 7 cols 50}}}
    {zen_currency:text(currency),optional\
	 {label "template::widget::currency (cost of nirvana)"}\
	 {value {"" "10000" "00"}}}
    {zen_date:date,to_sql(sql_date),from_sql(sql_date) {label "template::widget::date "} {format "Mon/DD/YYYY HH12:MI AM"}}
    {zen_file:text(file),optional\
	 {label "template::widget::file"}}
    {zen_hidden:text(hidden)\
	 {label "template::widget::hidden"}\
	 {value "42"}}
    {zen_inform:text(inform)\
	 {label "template::widget::inform"}\
	 {value {"Are you informed on being zen?"}}}
    {zen_multiselect:text(multiselect)\
	 {label "template::widget::multiselect"}\
	 {options {"mark" "emma" "avni" "carl" "don"}}}
    {zen_password:text(password)\
	 {label "template::widget::password"}}
    {zen_radio:text(radio)\
	 {label "template::widget::radio"}\
	 {options {"baccus" "blesius" "khatri" "raffenne" "wylie"}}}
    {zen_richtext:text(richtext)\
	 {label "template::widget::richtext"}\
	 {html {rows 7 cols 50}}}
    {zen_search:text(search)\
	 {label "template::widget::search"}}
    {zen_select:text(select)\
	 {label "template::widget::select"}\
	 {options {{"baroque" "b"} {"cubism" "c"} {"expressionism" "e"} {"impressionism" "i"} {"pop art" "pa"} {"surrealism" "s"}}}}
    {zen_select_locales:text(select_locales)\
	 {label "template::widget::select_locales"}\
	 {options {{en en} {es es} {fr fr} {de de}}}}
    {zen_submit:text(submit)\
	 {label "template::widget::submit"}\
	 {value "You will submit"}}
    {zen_text:text(text),optional,nospell\
	 {label "template::widget::text"}\
	 {help_text {"Your identification tag number"}}}
    {zen_textarea:text(textarea),optional,nospell\
	 {label "template::widget::textarea"}\
	 {help_text {"Please describe your desired state of being"}}\
	 {html {rows 7 cols 50}}}
}