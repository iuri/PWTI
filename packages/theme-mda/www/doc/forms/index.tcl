
ad_page_contract {
    A Sample Zen Form
    standard.adp
   
    @creation-date 2/1/2007
    @cvs-id $Id: index.tcl,v 1.1.2.4 2007/03/18 23:16:17 avni Exp $
} {
    {zen_id:naturalnum,optional 42}
}

ad_form -name "your_zen_level" -method post -html {enctype multipart/form-data class margin-form} -fieldset {{title "T1" class "C1"} \
														 "<b>Form using margin-form class</b>"} \
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
	 {category_tree_id 3064}}
    {zen_checkbox:text(checkbox),multiple,optional\
	 {label "template::widget::checkbox"}\
	 {options {{Uncertain u} {"Somewhat zen" sz} {"Chaotic" ch} {"Calm" c} {"Fully zen" fz}}}\
	 {legendtext "Checkbox fieldset legend with class"}\
	 {legend {class "myclass" id "myid"}}\
	 {fieldset {class "myfieldsetclass" id "myfieldsetid"}}} 
    {-section "sec1" {legendtext "Section I Title"}}
    {zen_comment:text(comment)\
	 {label "template::widget::comment"}\
	 {value "Please enter your comments here on what reaching nirvana will mean for you."}\
	 {html {rows 7 cols 50}}}
    {zen_currency:text(currency),optional\
	 {label "template::widget::currency (cost of nirvana)"}\
	 {value {"" "10000" "00"}}}
    {zen_date:date,to_sql(sql_date),from_sql(sql_date) {label "template::widget::date "} {format "Mon/DD/YYYY HH12:MI AM"} {help}}
    {zen_file:text(file),optional\
	 {label "template::widget::file"}}
    {zen_hidden:text(hidden)\
	 {label "template::widget::hidden"}\
	 {value "42"}}
    {zen_inform:text(inform)\
	 {label "template::widget::inform"}\
	 {value {"Are you informed on being zen?"}}}
    {-section ""}
    {zen_multiselect:text(multiselect)\
	 {label "template::widget::multiselect"}\
	 {options {"mark" "emma" "avni" "carl" "don"}}}
    {zen_password:text(password)\
	 {label "template::widget::password"}}
    {zen_radio:text(radio)\
	 {label "template::widget::radio"}\
	 {options {{"baccus" "don"} {"blesius" "carl"} {"khatri" "avni"} {"raffenne" "emma"} {"wylie" "mark"}}}\
	 {legendtext "Radio fieldset legend with no class"}}
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
    {-section "sec2" {legendtext "Section 2 Title"}}
    {zen_textarea:text(textarea),optional,nospell\
	 {label "template::widget::textarea"}\
	 {help_text {"Please describe your desired state of being"}}\
	 {html {rows 7 cols 50}}}
}