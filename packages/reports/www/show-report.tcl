ad_page_contract {

	Show Report by report_id

} {
	report_id:integer
	{group_filter:integer ""}
	{data_filter:integer ""}
	{filter:integer ""}
	{chart_type "bar"}
	{return_url ""}
}

permission::require_permission -object_id [ad_conn package_id] -privilege read

set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]



if {$chart_type == "bar"} {
	set report_size "600px"
} else {
	set report_size "500px"
}
set format $chart_type

set filters [reports::attributes::get_attributes -report_id $report_id -type "filter"]
set groups [reports::attributes::get_attributes -report_id $report_id -type "group"] 
set datas [reports::attributes::get_attributes -report_id $report_id -type "data"]
set table_name [reports::get_table_name -report_id $report_id]

if {[string equal "" $filters] || [string equal "" $groups] || [string equal "" $datas]} {
	if {[acs_user::site_wide_admin_p]} {
		ad_returnredirect "attribute-new?report_id=$report_id"
	} else {
		ad_returnredirect -message "[_ reports.Report_not_available]" $return_url
	}
}

set filters_reference [reports::attributes::get_filters_reference -report_id $report_id] 

if {$data_filter == ""} {
	set data_filter [lindex [lindex $datas 0] 1]
}

if {$group_filter == ""} {
	set group_filter [lindex [lindex $groups 0] 1]
}

if {$filter == ""} {
	set filter [lindex [lindex $filters 0] 1]
}

set group_filter_value [reports::attributes::get_value -attribute_id $group_filter]
set data_filter_value [reports::attributes::get_value -attribute_id $data_filter]
set data_filter_reference [reports::attributes::get_reference -attribute_id $data_filter]
set filter_value [reports::attributes::get_value -attribute_id $filter]




#### output cvs
template::list::create \
    -name "show_report" \
    -multirow get_data \
    -selected_format list \
    -elements {
        group {
            label "[_ reports.Group]"
        }
		data {
            label "[_ reports.Data]"
        }
     } -formats {
         list {
            label "[_ reports.Table]"
	   		layout "none"
	    	template {<listelement name="group">;<listelement name="data">\\n}
	    	row {
				group {}
				data {}
	    	}
         }  
    } 
 
template::list::create \
    -name "show_list" \
    -multirow get_data \
    -key {report_id} \
    -elements {
		group {
            label "[_ reports.Group]"
        }
		data {
            label "[_ reports.Value]"
        }
    } \
    -sub_class {
        narrow
    } -html {
        width 100%
    } -filters {
		group_filter {
			label "[_ reports.Groups]"
			values {$groups}
		}
		data_filter {
			label "[_ reports.Data]"
			values {$datas}
		}
		filter {
		    label "[_ reports.Filters]"
		    values {$filters}
		    where_clause "$filters_reference = :filter_value"
		}
        report_id {}
		chart_type {
			label "[_ reports.Chart_type]"
			values {{{#reports.pie#} pie} {{#reports.bar#} bar}}
		}
	}


set query "query_num"

if {$data_filter_reference != ""} {
	set query "query_reference"
}



db_multirow get_data $query {} {
		set data [format "%0.2f" $data]
}


template::list::create \
    -name "show_attributes" \
	-multirow attributes \
	-elements {
		pretty_name {
            label "[_ reports.Pretty_name]"
        }
		type {
            label "[_ reports.Type]"
        }
		reference {
			label "[_ reports.Reference]"
		}
		value {
			label "[_ reports.Value]"
		}
		attribute_del {
            display_template "<a href=\"attribute-del?attribute_id=@attributes.attribute_id@&report_id=@attributes.report_id@\">Del</a>"
        }
		attribute_edit {
            display_template "<a href=\"attribute-new?attribute_id=@attributes.attribute_id@&report_id=@attributes.report_id@\">Edit</a>"
        }
    } -html {
        width 100%
	}

db_multirow attributes get_attributes {}
