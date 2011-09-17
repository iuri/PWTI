<master src="../../../../../www/blank-master">
<property title="Floating Clipboard"></property>

<link rel="stylesheet" type="text/css" href="/resources/acs-subsite/site-master.css" media="all">

<script language=javascript>

  top.treeFrame.setCurrentFolder('@mount_point@', '@id@', '@parent_id@');

  function mark_and_reload(mount_point, id) {
    mark('@package_url@', mount_point, id, '@clipboardfloats_p@');
    window.location.reload();
  }

</script> 

<br/>
<strong>Clipboard</strong> <a href="javascript:window.close()">(close window)</a>
<br/><br/>

<div id="subnavbar-div">
  <div id="subnavbar-container">
    <div id="subnavbar">

 <if @clip_tab@ eq main>
   <div class="tab" id="subnavbar-here">
     Main Menu
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/clipboard/floating?mount_point=@mount_point@&clip_tab=main" title="" class="navbar-unselected">Main Menu</a>
   </div>
 </else>

 <if @clip_tab@ eq sitemap>
   <div class="tab" id="subnavbar-here">
     Content
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/clipboard/floating?mount_point=@mount_point@&clip_tab=sitemap" title="" class="navbar-unselected">Content</a>
   </div>
 </else>

 <if @clip_tab@ eq templates>
   <div class="tab" id="subnavbar-here">
     Templates
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/clipboard/floating?mount_point=@mount_point@&clip_tab=templates" title="" class="navbar-unselected">Templates</a>
   </div>
 </else>

 <if @clip_tab@ eq types>
   <div class="tab" id="subnavbar-here">
     Types
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/clipboard/floating?mount_point=@mount_point@&clip_tab=types" title="" class="navbar-unselected">Types</a>
   </div>
 </else>

 <if @clip_tab@ eq search>
   <div class="tab" id="subnavbar-here">
     Search
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/clipboard/floating?mount_point=@mount_point@&clip_tab=search" title="" class="navbar-unselected">Search</a>
   </div>
 </else>

 <if @clip_tab@ eq keywords>
   <div class="tab" id="subnavbar-here">
     Keywords
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/clipboard/floating?mount_point=@mount_point@&clip_tab=keywords" title="" class="navbar-unselected">Keywords</a>
   </div>
 </else>

  </div>
 </div>
</div>

<div id="subnavbar-body">

<if @id@ nil>

  <if @total_items@ gt 0>
    <p>There are a total of @total_items@ items on the clipboard. Select one of
    the mount points on the left to view a list of clipped items for the
    mount point.</p>

    <p><a href="clear-clipboard?float_p=1">Clear the clipboard</a></p>
 
  </if>
  <else>
    There are no items on the clipboard.
  </else>
  
</if>
<else>

<h2>Clipped Items</h2>

<if @items:rowcount@ gt 0>

  <table border=0 cellpadding=4 cellspacing=0>

  <multiple name=items>
  <tr>
    <td>
      <a href="javascript:mark_and_reload('@id@', '@items.item_id@')"><img 
	 src="../../resources/Delete24.gif" width=24 height=24 
	 border=0></a>
    </td>
    <td>
      <a href="@items.url@" target=listFrame>@items.item_path@</a>
    </td>
  </tr>
  </multiple>
  </table>
</if>
<else><p><i>No items</i></p></else>

</else>

</body>
</html>
