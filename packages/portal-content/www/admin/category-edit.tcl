ad_page_contract {
    Add or edit a category.
} {
    keyword_id:integer,optional
    parent_id:integer,optional
    {type_p "f"}
}

set project_name [portal_content::conn project_name]

if { (![info exists keyword_id] && ![info exists parent_id]) || [string equal $type_p "t"] } {
    set object_type_name [_ portal-content.Category_Type]
} else {
    set object_type_name [_ portal-content.Category]
}

if { [info exists keyword_id] } {
    set function [_ acs-kernel.common_edit]
} else {
    set function [_ acs-kernel.common_add]
}

set page_title [_ portal-content.function]
set context_bar [ad_context_bar [list categories [_ portal-content.Manage_Categories]] $page_title]


ad_form -name keyword -cancel_url categories -form {
    {keyword_id:key(acs_object_id_seq)}
    {parent_id:integer(hidden)}
    {heading:text {label $object_type_name}}
} -new_request {
    if { ![exists_and_not_null parent_id] } {
        set parent_id [portal_content::conn project_root_keyword_id]
    }
} -select_query {
    select child.parent_id, 
           child.heading
    from   cr_keywords child
    where  child.keyword_id = :keyword_id
} -edit_data {
    cr::keyword::set_heading \
        -keyword_id $keyword_id \
        -heading $heading
} -new_data {
    cr::keyword::new \
        -heading $heading \
        -parent_id $parent_id \
        -keyword_id $keyword_id
} -after_submit {
    portal_content::get_keywords_flush
    ad_returnredirect categories
    ad_script_abort
}
