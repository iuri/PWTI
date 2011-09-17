<?xml version="1.0"?>
<queryset>
<fullquery name="query_num">
    <querytext>
		SELECT $group_filter_value as group, SUM($data_filter_value) as data
		FROM $table_name
		where $data_filter_value is not null
    	[template::list::filter_where_clauses -and -name show_list]
		group by $group_filter_value
		ORDER BY $group_filter_value
    </querytext>
</fullquery>

<fullquery name="query_reference">
    <querytext>
	SELECT $group_filter_value as group, (SUM($data_filter_value) * 100 / SUM($data_filter_reference) )  as data
	FROM $table_name
	where $data_filter_value is not null
    [template::list::filter_where_clauses -and -name show_list]
	group by $group_filter_value
	ORDER BY $group_filter_value
    </querytext>
</fullquery>

<fullquery name="get_attributes">
    <querytext>
	select report_id, attribute_id, reference, pretty_name, value, type
	from reports_attributes
	where report_id = :report_id
    </querytext>
</fullquery>


</queryset>
