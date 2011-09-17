<div class="portlet-wrapper <if @admin_p@>itemDrag</if>" id="e@element_id@">
  <div class="portlet-header">
    <div class="portlet-title">
      <if @title_p@ eq t>
        <h3 id="@ds_name@">
	  <if @customize@>
	    <span>(<a href="admin/portal/element-hide?element_id=@element_id@&amp;return_url=@return_url@">hide </a>) 
	          (<a href="admin/portal/element-hide-title?element_id=@element_id@&amp;value=f&amp;return_url=@return_url@">hide title</a>) 
		  (<a href="admin/portal/element-delete?element_id=@element_id@&amp;value=f&amp;return_url=@return_url@">remove</a>)
            </span>
	  </if>
	</h3>
      </if>
      <else>
        <if @customize@><h3><span><a href="admin/portal/element-hide-title?element_id=@element_id@&amp;value=t&amp;return_url=@return_url@">V</a></span></h3></if>
      </else>
    </div>
    <div class="portlet-controls"></div>
  </div>
  <div class="portlet">
    <slave>
  </div> <!-- /portlet -->
</div> <!-- /portlet-wrapper -->
