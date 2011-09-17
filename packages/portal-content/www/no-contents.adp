<master src="../lib/master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<p>
  <i>#portal-content.This_project_is_empty#</i>
</p>

<if @admin_p@ true>
  <p>
    <b>&raquo;</b> <a href="admin/">#portal-content.Project_administration#</a>
  </p>
</if>

<p>
  <b>&raquo;</b> <a href="content-add">#portal-content.Submit_a_new_content#</a>
</p>


