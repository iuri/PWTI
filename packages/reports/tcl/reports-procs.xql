<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="reports::attributes::get_attributes.get_attributes">      
      <querytext>
		select pretty_name, attribute_id
		from reports_attributes 
		where type = :type
		and report_id = :report_id
	 </querytext>
</fullquery>
	
<fullquery name="reports::get.get_report">      
      <querytext>
		select report_name, table_name
		from reports
		where report_id = :report_id
	 </querytext>
</fullquery>
	
<fullquery name="reports::attributes::get.get_attribute">
      <querytext>
		select report_id,
			   attribute_id,
			   type, 
			   pretty_name,
			   reference,
			   value
		from reports_attributes
		where attribute_id = :attribute_id
	 </querytext>
</fullquery>
	
<fullquery name="reports::get_table_name.get_table_name">      
      <querytext>
		select table_name
		from reports 
		where report_id = :report_id
	 </querytext>
</fullquery>

<fullquery name="reports::attributes::get_filters_reference.get_filters_reference">
      <querytext>
		select reference
		from reports_attributes 
		where type = 'filter'
		and report_id = :report_id
		limit 1
	 </querytext>
</fullquery>

<fullquery name="reports::attributes::get_value.get_attribute_value">
      <querytext>
		select value
		from reports_attributes 
		where attribute_id = :attribute_id
	 </querytext>
</fullquery>

<fullquery name="reports::attributes::get_reference.get_attribute_reference">
      <querytext>
		select reference
		from reports_attributes 
		where attribute_id = :attribute_id
	 </querytext>
</fullquery>


</queryset>

