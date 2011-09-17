ad_page_contract {
	Show Report to this package_id
}


permission::require_permission -object_id [ad_conn package_id] -privilege admin

set package_id [ad_conn package_id]
template::list::create -name reports -multirow reports \
        -actions {{#reports.Add_new_report#} {report-new}} \
        -elements {
                report_name {
                    link_url_col link
                }
                table_name {}
                attribute_add {
                    display_template "<a href=\"attribute-new?report_id=@reports.report_id@\">Attribute Add</a>"
                }
				report_del {
                    display_template "<a href=\"report-del?report_id=@reports.report_id@\">Del</a>"
                }
				report_edit {
                    display_template "<a href=\"report-new?report_id=@reports.report_id@\">Edit</a>"
                }
        }

db_multirow -extend link reports select_forms {select report_id, report_name, table_name from reports r, acs_objects ao where ao.object_id = r.report_id and ao.package_id = :package_id} {
    set link "show-report?report_id=$report_id"
}








