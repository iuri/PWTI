<div id="subnavbar-div">
  <div id="subnavbar-container">
    <div id="subnavbar">

 <if @item_props_tab@ eq editing>
   <div class="tab" id="subnavbar-here">
     Editing
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/items/index?item_id=@item_id@&mount_point=sitemap&item_props_tab=editing" title="" class="subnavbar-unselected">Editing</a>
   </div>
 </else>

 <if @item_props_tab@ eq related>
   <div class="tab" id="subnavbar-here">
     Related Content
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/items/index?item_id=@item_id@&mount_point=sitemap&item_props_tab=related" title="" class="subnavbar-unselected">Related Content</a>
   </div>
 </else>

 <if @item_props_tab@ eq categories>
   <div class="tab" id="subnavbar-here">
     Categories
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/items/index?item_id=@item_id@&mount_point=sitemap&item_props_tab=categories" title="" class="subnavbar-unselected">Categories</a>
   </div>
 </else>

 <if @item_props_tab@ eq publishing>
   <div class="tab" id="subnavbar-here">
     Publishing
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/items/index?item_id=@item_id@&mount_point=sitemap&item_props_tab=publishing" title="" class="subnavbar-unselected">Publishing</a>
   </div>
 </else>

 <if @item_props_tab@ eq permissions>
   <div class="tab" id="subnavbar-here">
     Permissions
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/items/index?item_id=@item_id@&mount_point=sitemap&item_props_tab=permissions" title="" class="subnavbar-unselected">Permissions</a>
   </div>
 </else>

  </div>
 </div>
</div>

