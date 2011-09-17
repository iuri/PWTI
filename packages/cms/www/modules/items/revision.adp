<master src="../../master">
<property name="title">@page_title;noquote@</property>

<include src="item-header" item_id="@item_id@" mount_point="sitemap">

<include src="item-tabs" item_id="@item_id@" item_props_tab="editing">

<div id="subnavbar-body">

 <div id=section>
  <div id=section-header>@page_title@ (@content_type@)</div>

   <p/>

   <if @content_size@ gt 1>
     <if @is_text_mime_type@ eq t>@content;noquote@</if>
     <else>
       <if @is_image_mime_type@ eq t>
          <img src="content-download?revision_id=@revision_id@">
       </if>
       <else>
          <a href="content-download?revision_id=@revision_id@">View Content</a>
       </else>
     </else>
   </if>
   <else>No Content</else>

   <p/>

   <ul class="action-links">
    <if @content_size@ le 1>
     <if @write_p@>
       <li>There is no content. <a href="content-add-1?revision_id=@revision_id@">
         Create new content for this item</a></li>
     </if>
    </if>
    <if @write_p@>
     <li><a href="revision-add-1?item_id=@item_id@">
        Add a revision this content item</a></li>
    </if>
    <if @live_revision_p@ eq 1>
     <li>This revision is live. &nbsp;
      <a href="unpublish?item_id=@item_id@">Unpublish</a></li>
    </if>
    <else>
     <if @is_publishable@ eq t>
      <li><a href="publish?item_id=@item_id@&revision_id=@revision_id@">
        Make this revision live</a></li>
     </if>
    </else>
    <li><a href="index?item_id=@item_id@">Back to the content item</a></li>
   </ul>

 </div>
</div>
