
<if @admin_p@> 
	<if @customize_p@>
		<p>#theme-mda.Customize_portal_On# <a href="admin/portal/portal-customize-turn?portal_id=@portal_id@&amp;return_url=@return_url@">#theme-mda.Customize_portal_turn_off#</a></p>

		<div class="portal_customize_elements">
			<ul>
			<multiple name="hidden_elements_list">
			    <li><a href="admin/portal/portal-configure-2?element_id=@hidden_elements_list.element_id@&amp;page_id=@page_id@&amp;portal_id=@portal_id@&amp;op_show_here=Show Here&amp;region=1&amp;return_url=@return_url@">@hidden_elements_list.element_name@</a></li>
			</multiple> 
			</ul>
		</div>
	
		<div class="portal_customize_layout">
			<ul>
			<multiple name="layouts_list">
			    <li><img src="/resources/theme-mda/images/@layouts_list.image@.gif"><span class="tipo_disposicao"><a href="admin/portal/portal-layout?page_id=@page_id@&amp;portal_id=@portal_id@&amp;layout_id=@layouts_list.layout_id@&amp;return_url=@return_url@">@layouts_list.name@</a></span><br /><a href="admin/portal/portal-layout?page_id=@page_id@&amp;portal_id=@portal_id@&amp;layout_id=@layouts_list.layout_id@&amp;return_url=@return_url@">Selecionar disposição</a></li>
			</multiple>
			</ul> 
		</div>
	</if>
	<else>
			<p>#theme-mda.Customize_portal_Off# <a href="admin/portal/portal-customize-turn?portal_id=@portal_id@&amp;return_url=@return_url@">#theme-mda.Customize_portal_turn_on#</a></p>
	</else>
</if>

<slave>

<if @admin_p@>
	<script type="text/javascript" src="/resources/theme-mda/js/customize/@columns@colums.js"></script>
</if>
