<div class="portlet-wrapper <if @admin_p@>itemDrag</if>" id="@element_id@">
      	<if @title_p@ eq t><h3 class="portlet_title" id="@ds_name@">@name;noquote@ <if @customize@><span><a href="admin/portal/element-hide?element_id=@element_id@&return_url=@return_url@">x</a><a href="admin/portal/element-hide-title?element_id=@element_id@&value=f&return_url=@return_url@">X</a></span></if></h3></if><else><if @customize@><h3 class="portlet_title"><a href="admin/portal/element-hide-title?element_id=@element_id@&value=t&return_url=@return_url@">V</a></h3></if></else>
    	<slave>
</div>
