ad_page_contract {
    page to select a new folder to move a file into (Actually, this should 
    work to move folders too)

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @creation-date 13 Nov 2000
    @cvs-id $Id: file-move.tcl,v 1.5 2005/05/26 08:28:46 maltes Exp $
} {
    file_id:integer,notnull
} -validate {
    valid_file -requires {file_id} {
	if ![fs_file_p $file_id] {
	    ad_complain "[_ file-storage.lt_The_specified_file_is]"
	}
    }
} -properties {
    file_id:onevalue
    file_name:onevalue
    context:onevalue
}

# check they have write permission on the file (is this really the
# right permission?)

ad_require_permission $file_id write

# set templating datasources

set file_name [db_exec_plsql file_name "
begin
    :1 := file_storage.get_title(:file_id);
end;"]

set context [fs_context_bar_list -final "[_ file-storage.Move]" $file_id]

ad_return_template


