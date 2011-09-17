<master src="../../master">
<property name="title">Upload new template revision</property>

<include src="template-header" mount_point=@mount_point@ item_id=@template_id@ template_props_tab=@template_props_tab@>

<include src="template-tabs" mount_point=@mount_point@ item_id=@template_id@ template_props_tab=@template_props_tab@>

<div id="subnavbar-body">

 <div id=section>
  <div id=section-header>Upload Template @path;noquote@</div>
   <p/>
   <formtemplate id="edit_template"></formtemplate>
 </div>

</div>

