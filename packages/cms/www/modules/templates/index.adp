<master src="../../master">
<property name="title">@page_title@</property>

<p/>

<include src="../../bookmark" mount_point="@mount_point@" id="@folder_id@">

@page_title;noquote@ 

<p/>

&nbsp;&nbsp;&nbsp;
<if @info.description@ not nil>@info.description@</if>
<else>No description</else>

<p/>

<include src="../sitemap/ancestors" item_id="@folder_id@" mount_point="@mount_point@">

<p/>

<include src="../../../lib/folder-items" folder_id="@folder_id@"
  parent_id="@parent_id@" actions="@actions;noquote@" 
  orderby="@orderby@" page="@page@" mount_point="@mount_point@" />


<script language=JavaScript>
  set_marks('@mount_point@', '../../resources/checked');
</script>