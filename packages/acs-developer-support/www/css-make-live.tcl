# 

ad_page_contract {
    
    make a css revision the live one
    
    @author Malte Sussdorff (malte.sussdorff@cognovis.de)
    @creation-date 2007-09-30
    @cvs-id $Id: css-make-live.tcl,v 1.1 2007/10/05 12:02:38 maltes Exp $
} {
    {revision_id:integer}
    {file_location }
    {return_url_2 "/"}
} -properties {
} -validate {
} -errors {
}


content::item::set_live_revision -revision_id $revision_id

set item_id [content::revision::item_id -revision_id $revision_id]
#set target [content::item::get_name -item_id $item_id]
set target $file_location
set source [content::revision::get_cr_file_path -revision_id $revision_id]

#todo check if files are stored in db
file copy -force $source $target

ad_returnredirect $return_url_2
