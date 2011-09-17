<master src="../../master">
<property name="title">Form Widget Wizard</property>

<include src="types-header" content_type="@content_type@">

<include src="types-tabs" content_type="@content_type@" type_props_tab="attributes">

<div id="subnavbar-body">

 <div id=section>
  <div id=section-header>Form Widget Wizard</div>
   <p/>
    <multiple name="wizard">

     <if @wizard.id@ ne @wizard:current_id@>
      <a href="@wizard.link@">@wizard.rownum@. @wizard.label@</a>  
     </if>
     <else>
      @wizard.rownum@. @wizard.label@
     </else>  
     <if @wizard.rownum@ lt @wizard:rowcount@> &sect; </if>
    </multiple>

    <hr>
    <include src="@wizard:current_url;noquote@">
 </div>

</div>

