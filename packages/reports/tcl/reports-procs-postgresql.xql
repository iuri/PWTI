<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="reports::new.insert_report">      
      <querytext>
		select reports__new (
			:report_id,		-- report_id
		    :report_name, 	-- report_name
		    :table_name, 	-- table
		    :package_id, 	-- package_id
		    now(), 			-- creation_date
		    :user_id, 		-- creation_user
		    :creation_ip, 	-- creation_ip
		    :context_id  	-- context_id
		)
      </querytext>
</fullquery>

<fullquery name="reports::edit.report_edit">      
      <querytext>
		select reports__edit (
			:report_id,		-- report_id
		    :report_name, 	-- report_name
		    :table_name 	-- table
		)
      </querytext>
</fullquery>

<fullquery name="reports::attributes::edit.attribute_edit">
      <querytext>
		select reports_attributes__edit (
			  :attribute_id,	-- attribute_id
			  :report_id, 		-- report_id
			  :type, 			-- type
			  :value, 			-- value
			  :pretty_name,		-- pretty_name
			  :reference		-- reference
		)
      </querytext>
</fullquery>


<fullquery name="reports::del.report_del">      
      <querytext>
		select reports__del (
			:report_id		-- report_id
		)
      </querytext>
</fullquery>

<fullquery name="reports::attributes::del.attribute_del">      
      <querytext>
		select reports_attributes__del (
			:attribute_id		-- attribute_id
		)
      </querytext>
</fullquery>



<fullquery name="reports::attributes::new.insert_attribute">      
      <querytext>
		select reports_attributes__new (
			:attribute_id,	-- attribute_id
			:report_id, 	-- report_id
		    :type,		 	-- type
		    :value, 		-- value
			:pretty_name,	-- pretty_name
			:reference,		-- reference
		    :package_id, 	-- package_id
		    now(), 			-- creation_date
		    :user_id, 		-- creation_user
		    :creation_ip, 	-- creation_ip
		    :context_id  	-- context_id
		)
      </querytext>
</fullquery>


</queryset>

