<master src="../../master">
<property name="title">@page_title;noquote@</property>

<include src="types-header" content_type="@content_type@">

<include src="types-tabs" content_type="@content_type@" type_props_tab="@type_props_tab@">

<div id="subnavbar-body">

 <div id=section>
  <div id=section-header>@page_title@</div>
   <p/>
    <if @invalid_content_type_p@ eq t>
     This is an invalid content type.
    </if>
    <else>
     <if @template_count@ eq 0>
      There are no templates in the clipboard.
     </if>
     <else>
      <formtemplate id="register_templates"></formtemplate>
     </else>
    </else>
 </div>

</div>
