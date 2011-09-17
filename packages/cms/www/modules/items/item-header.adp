<nobr>
<p>
<include src="../../bookmark" mount_point="@mount_point@" id="@item_id@">
@page_title;noquote@ 
</p>
</nobr>
<p/>

&nbsp;&nbsp;&nbsp;
<if @description@ not nil>@description;noquote@</if>
<else>No description</else>

<p/>

<include src="../sitemap/ancestors" item_id=@item_id@>

<p/>
