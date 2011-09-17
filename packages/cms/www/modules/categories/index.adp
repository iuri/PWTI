<master src="../../master">
<property name="title">@page_title@</property>

<p/>

<include src="../../bookmark" mount_point="@mount_point@" id="@original_id@">

@page_title;noquote@

<p/>

&nbsp;&nbsp;&nbsp;
<if @info.description@ not nil>@info.description@</if>
<else>No description</else>

<p/>

<if @parent_url@ not nil>
 back to <a href=@parent_url@>@parent_heading@</a>
</if>

<p/>

<listtemplate name="items"></listtemplate>

<script language=JavaScript>
  set_marks('@mount_point@', '../../resources/checked');
</script>





