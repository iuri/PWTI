	<div <if @admin_p@>class="itemDrag"</if>" id="@element_id@">
	<if @title_p@ eq t><h3 class="portlet_title" id="@ds_name@"><span>@name;noquote@ <if @customize@><span><a href="admin/portal/element-hide?element_id=@element_id@&return_url=@return_url@">x</a><a href="admin/portal/element-hide-title?element_id=@element_id@&value=f&return_url=@return_url@">X</a></span></if></span></h3></if><else><if @customize@><h3><span><a href="admin/portal/element-hide-title?element_id=@element_id@&value=t&return_url=@return_url@">V</a><span></h3></if></else>
		<div class="portlet-wrapper">
    		<slave>
		</div>
	</div>
