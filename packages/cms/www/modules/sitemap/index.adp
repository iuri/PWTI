<master src="../../master">
<property name="title">@page_title@</property>

<p/>

<include src="../../bookmark" mount_point="@mount_point@" id="@original_folder_id@">

@page_title;noquote@ 

<p/>

&nbsp;&nbsp;&nbsp;
<if @info.description@ not nil>@info.description@</if>
<else>No description</else>

<p/>

<include src="ancestors" item_id=@original_folder_id@ 
  index_page_id=@index_page_id@ 
  mount_point=@mount_point@ />

<p/>

<include src="../../../lib/folder-items" folder_id="@folder_id@"
  parent_id="@parent_id@" actions="@actions;noquote@" 
  orderby="@orderby@" page="@page@" mount_point="@mount_point@" />


<p/>

<if @symlinks:rowcount@ gt 0>
  <b>Links to this folder</b>: 

  <table border=0 cellpadding=4 cellspacing=0>
  <multiple name=symlinks>
    <tr><td>
      <a href="index?id=@symlinks.id@">
        <img src="../../resources/shortcut.gif" border=0>
        @symlinks.path@ 
      </a>
    </td></tr>
  </multiple>
  </table>
  <br>
</if>

<if @mount_point@ eq sitemap>
  <if @num_revision_types@ gt 0>
   <ul class="action-links">
    <li><formtemplate id=add_item>
     <formwidget id=folder_id>
     <formwidget id=mount_point>
     Add a new <formwidget id=content_type>
     </formtemplate></li>
   </ul>
  </if>
</if>

<script language=JavaScript>
  set_marks('@mount_point@', '../../resources/checked');
</script>
