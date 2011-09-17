<master src="customize-portal">
<property name="portal_id">@portal_id@</property>
<property name="page_id">@page_id@</property>
<property name="columns">3</property>

<div class="main">
	<div class="top-content">
		<div class="top-content-padding getDrag">
    		<list name="element_ids_1">
		      <include src="@element_src@"
		        element_id="@element_ids_1:item@"
		        element_num="@element_ids_1:rownum@"
		        element_first_num="0"
		        action_string="@action_string@"
		        theme_id="@theme_id@"
		        region="1"
		        portal_id="@portal_id@"
		        edit_p="@edit_p@"
		        return_url="@return_url@"
		        hide_links_p="@hide_links_p@"
		        page_id="@page_id@"
		        layout_id="@layout_id@">
    		</list>
		</div>
	</div>

	<div class="main-content">
		<div class="main-content-padding getDrag">
      			<list name="element_ids_2">
		        <include src="@element_src@"
		          element_id="@element_ids_2:item@"
		          element_num="@element_ids_2:rownum@"
		          element_first_num="@element_2_first_num@"
		          action_string="@action_string@"
		          theme_id="@theme_id@"
		          region="2"
		          portal_id="@portal_id@"
		          edit_p="@edit_p@"
		          return_url="@return_url@"
		          hide_links_p="@hide_links_p@"
		          page_id="@page_id@"
        		  layout_id="@layout_id@">
		      </list>
		</div>
    </div> 
	<div class="bottom-content">
		<div class="bottom-content-padding getDrag">
			  <list name="element_ids_3">
			      <include src="@element_src@"
			        element_id="@element_ids_3:item@"
			        element_num="@element_ids_3:rownum@"
    	    		element_first_num="@element_3_first_num@"
			        action_string="@action_string@"
			        theme_id="@theme_id@"
			        region="3"
			        portal_id="@portal_id@"
			        edit_p="@edit_p@"
			        return_url="@return_url@"
			        hide_links_p="@hide_links_p@"
			        page_id="@page_id@"
    		    	layout_id="@layout_id@">
		    </list>
		</div>
	</div>

</div>

