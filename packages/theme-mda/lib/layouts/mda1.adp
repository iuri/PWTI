<master src="customize-portal">
<property name="portal_id">@portal_id@</property>
<property name="page_id">@page_id@</property>
<property name="columns">1</property>



<div id="main">
  <div id="main-content">
    <div class="main-content-padding getDrag">
      <list name="element_ids_1">
        <include src="@element_src@" 
          element_id="@element_ids_1:item@" 
          element_num="@element_ids_1:rownum@"
          element_first_num="0"
          action_string=@action_string@ 
          theme_id=@theme_id@ 
          region="1" 
          portal_id=@portal_id@ 
          edit_p=@edit_p@
          return_url=@return_url@ 
          hide_links_p=@hide_links_p@
          page_id=@page_id@ 
          layout_id=@layout_id@>
      </list>
    </div> <!-- /main-content-padding -->
  </div> <!-- /main-content -->
</div> <!-- /main -->


