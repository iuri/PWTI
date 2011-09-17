<master src="customize-portal">
<property name="portal_id">@portal_id@</property>
<property name="page_id">@page_id@</property>
<property name="columns">5</property>


<div class="top-main-content">
  <div class="top-main-content-padding getDrag">
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

<div class="left-content">
  <div class="left-content-padding getDrag">
    <list name="element_ids_2">
		      <include src="@element_src@"
		        element_id="@element_ids_2:item@"
		        element_num="@element_ids_2:rownum@"
		        element_first_num="0"
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




<div class="main-content">
  <div class="main-content-padding getDrag">
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


	
<div class="bottom-left-content">
  <div class="right-content-padding getDrag">
    <list name="element_ids_4">
			      <include src="@element_src@"
			        element_id="@element_ids_4:item@"
			        element_num="@element_ids_4:rownum@"
    	    		element_first_num="@element_4_first_num@"
			        action_string="@action_string@"
			        theme_id="@theme_id@"
			        region="4"
			        portal_id="@portal_id@"
			        edit_p="@edit_p@"
			        return_url="@return_url@"
			        hide_links_p="@hide_links_p@"
			        page_id="@page_id@"
    		    	layout_id="@layout_id@">
    </list>
  </div>
</div>


<div class="bottom-right-content">
  <div class="bottom-content-padding getDrag">
    <list name="element_ids_5">
			      <include src="@element_src@"
			        element_id="@element_ids_5:item@"
			        element_num="@element_ids_5:rownum@"
				element_first_num="@element_5_first_num@"
			        action_string="@action_string@"
			        theme_id="@theme_id@"
			        region="5"
			        portal_id="@portal_id@"
			        edit_p="@edit_p@"
			        return_url="@return_url@"
			        hide_links_p="@hide_links_p@"
			        page_id="@page_id@"
    		    	layout_id="@layout_id@">
    </list>
  </div>
</div>

