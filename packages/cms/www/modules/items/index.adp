<master src="../../master">
<property name="title">@page_title@</property>

<include src="item-header" item_id="@item_id@" mount_point="sitemap">

<!-- Tabs -->

<include src="item-tabs" item_props_tab="@item_props_tab@" item_id="@item_id@">

<! -- Content -->

<div id="subnavbar-body">

<if @item_props_tab@ eq editing>

  <div id=section>
   <include src="attributes" revision_id="@info.latest_revision;noquote@">
  </div>
  <p>

  <div id=section>
   <include src="revisions" item_id="@item_id;noquote@">
  </div>
  <p>

</if>

<if @item_props_tab@ eq related>

  <div id=section>
   <div id=section-header>Child Items</div>
   <p/>
    <include src="children" item_id="@item_id;noquote@">
  </div>
  <p>

  <div id=section>
   <div id=section-header>Related Items</div>
   <p/>
    <include src="related-items" item_id="@item_id;noquote@">
  </div>
  <p>

</if>

<if @item_props_tab@ eq categories>

  <div id=section>
   <include src="keywords" item_id="@item_id;noquote@" mount_point="@mount_point;noquote@">  
  </div>

</if>

<if @item_props_tab@ eq publishing>

  <div id=section>
   <div id=section-header>Publishing Status</div>
   <p/>
    <include src="publish-status" item_id="@item_id;noquote@">
  </div>
  <p>

  <div id=section>
   <div id=section-header>Registered Templates</div>
   <p/>
    <include src="templates" item_id="@item_id;noquote@">
  </div>
  <p>

  <div id=section>
   <div id=section-header>Comments</div>
   <p/>
    Place holder for comments
  </div>
  <p>

</if>

<if @item_props_tab@ eq permissions>
  
  <div id=section>
  <div id=section-header>Item permissions</div>
   <include src="/packages/acs-subsite/www/permissions/perm-include" object_id="@item_id@">
  </div>
  <p/>

</if>

<!-- Options at the end -->

<if @can_edit_p@>
 <ul class="action-links">
  <li><a href="rename?item_id=@item_id@&mount_point=@mount_point@&item_props_tab=@item_props_tab@">
    Rename</a> this content item</li>
  <li><a href="delete?item_id=@item_id@&mount_point=@mount_point@" 
     onClick="return confirm('Warning! You are about to delete this content item.');">
     Delete</a> this content item</li>
 </ul>
</if>

</div>

<p>
