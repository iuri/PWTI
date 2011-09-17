<master src="../../master">
<property name="title">@page_title;noquote@</property>

<include src="types-header" content_type="@content_type@">

<include src="types-tabs" type_props_tab="@type_props_tab@" content_type="@content_type@" parent_type="@parent_type@">

<div id="subnavbar-body">

  <if @type_props_tab@ eq attributes>

    <div id=section>
    <include src="attributes" can_edit_widgets_p="@can_edit_widgets_p@" content_type="@content_type@">
    </div>
    <p/>

    <div id=section>
    <include src="mime-types" content_type="@content_type@">
    </div>
    <p/>

    <div id=section>
    <include src="content-method" content_type="@content_type@">
    </div>

 </if>

 <if @type_props_tab@ eq relations>

    <include src="relations" content_type=@content_type;noquote@>

 </if>

<if @type_props_tab@ eq templates>

    <div id=section>    
     <div id=section-header>Registered Templates</div>
      <p/>
      <listtemplate name="type_templates"></listtemplate>
    </div>

</if>

<if @type_props_tab@ eq permissions>

    <div id=section>    
     <div id=section-header>Permissions</div>
      <include src="/packages/acs-subsite/www/permissions/perm-include" object_id="@module_id@">
    </div>

</if>

<if @type_props_tab@ eq subtypes>
    
    <div id=section>
     <include src="subtypes" content_type=@content_type;noquote@ object_type_pretty=@object_type_pretty;noquote@>
    </div>

</if>

<br>

</div>

<script language=JavaScript>
  set_marks('@mount_point@', '../../resources/checked');
</script>
