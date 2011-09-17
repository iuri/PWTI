<master src="../../master">
<property name="title">@page_title@</property>

<include src="template-header" mount_point=@mount_point@ item_id=@item_id@ template_props_tab=@template_props_tab@>

<include src="template-tabs" mount_point=@mount_point@ item_id=@item_id@ template_props_tab=@template_props_tab@>

<div id="subnavbar-body">

<div id=section>
 <include src=@template_props_tab@ template_id=@item_id@>
</div>

<ul class="action-links">
 <li><a href="edit?template_id=@item_id@&template_props_tab=@template_props_tab@">Edit</a> this template in the browser</li>
 <li><a href="download?template_id=@item_id@&template_props_tab=@template_props_tab@">Save</a> the latest version of this template to a file</li>
 <li><a href="upload?template_id=@item_id@&template_props_tab=@template_props_tab@">Upload</a> a new version of this template</li>
</ul>

</div>