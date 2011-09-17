ad_library {

    Reports Library

    @creation-date 2009-02-6
    @author Alessandro Landim <alessandro.landim@gmail.com>
    @cvs-id $Id: videos-procs.tcl,v 1.21 2006/08/08 21:26:52 donb Exp $

}

namespace eval reports {}
namespace eval reports::attributes {}


ad_proc -public reports::new {
	{-report_id ""}
    {-report_name:required}
    {-table_name:required }
} {
    create a report
} {

    set user_id [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]
	set package_id [ad_conn package_id]
    set context_id [ad_conn package_id]

    db_exec_plsql insert_report ""
}

ad_proc -public reports::attributes::new {
	{-attribute_id ""}
	{-report_id:required}
	{-type:required}
	{-value:required}
	{-pretty_name:required}
	{-reference:required}
} {
    create a report
} {

    set user_id [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]
	set package_id [ad_conn package_id]
    set context_id [ad_conn package_id]

    db_exec_plsql insert_attribute ""
}

ad_proc -public reports::attributes::get_attributes {
	{-report_id:required}
	{-type:required}
} {
    Get attributes by type and report_id
} {
	return [db_list_of_lists get_attributes {}] 
}

ad_proc -public reports::get_table_name {
	{-report_id:required}
} {
    Get table name of report ID
} {
	return [db_string get_table_name {} -default ""]
}

ad_proc -public reports::get {
	{-report_id:required}
} {
    Get table name of report ID
} {
    upvar report row
	db_1row get_report {} -column_array row
}

ad_proc -public reports::attributes::get {
	{-attribute_id:required}
} {
    Get attribute 
} {
    upvar attribute row
	db_1row get_attribute {} -column_array row
}


ad_proc -public reports::edit {
	{-report_id:required}
    {-report_name:required}
    {-table_name:required}
} {
    Edit Report ID
} {
    db_exec_plsql report_edit ""
}

ad_proc -public reports::attributes::edit {
	{-attribute_id:required}
	{-report_id:required}
    {-type:required}
    {-value:required}
    {-pretty_name:required}
    {-reference:required}
} {
    Edit Attribute ID
} {
    db_exec_plsql attribute_edit ""
}

ad_proc -public reports::del {
	{-report_id:required}
} {
    Edit Report ID
} {
    db_exec_plsql report_del ""
}

ad_proc -public reports::attributes::del {
	{-attribute_id:required}
} {
    Delete Attribute  ID
} {
    db_exec_plsql attribute_del ""
}



ad_proc -public reports::attributes::get_filters_reference {
	{-report_id:required}
} {
    Get filters reference by report ID
} {
	return [db_string get_filters_reference {} -default ""] 
}

ad_proc -public reports::attributes::get_value {
	{-attribute_id:required}
} {
    Get attribute by attribute ID
} {
	return [db_string get_attribute_value {}]
}

ad_proc -public reports::attributes::get_reference {
	{-attribute_id:required}
} {
    Get attribute reference by attribute ID
} {
	return [db_string get_attribute_reference {}]
}

